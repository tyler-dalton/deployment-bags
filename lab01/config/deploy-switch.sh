#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$CONFIG_DIR/.env"
GOLDEN_CONFIG="$CONFIG_DIR/golden-config.txt"

usage() {
    echo "Usage: $0 <hostname>"
    echo "Example: $0 BG01-SW02"
    exit 1
}

[[ $# -eq 1 ]] || usage

HOSTNAME="$1"

# Load the local values
if [[ ! -f "$ENV_FILE" ]]; then
    echo "ERROR: Missing $ENV_FILE"
    echo "Create it from .env.example first."
    exit 1
fi

source "$ENV_FILE"

: "${TA_MAC_1:?TA_MAC_1 is not set in .env}"
: "${TA_MAC_2:?TA_MAC_2 is not set in .env}"

if [[ ! -f "$GOLDEN_CONFIG" ]]; then
    echo "ERROR: Missing $GOLDEN_CONFIG"
    exit 1
fi

# Detect serial interface
if [[ -n "${SERIAL_DEVICE:-}" ]]; then
    DEVICE="$SERIAL_DEVICE"
else
    mapfile -t SERIAL_DEVICES < <(compgen -G '/dev/ttyUSB*' || true)
    if [[ ${#SERIAL_DEVICES[@]} -eq 0 ]]; then
        echo "ERROR: No /dev/ttyUSB* serial device detected."
        exit 1
    elif [[ ${#SERIAL_DEVICES[@]} -gt 1 ]]; then
        echo "ERROR: Multiple serial devices detected: ${SERIAL_DEVICES[*]}"
        echo
        echo "Set SERIAL_DEVICE explicitly, for example:"
        echo "SERIAL_DEVICE=/dev/ttyUSB0 $0 $HOSTNAME"
        exit 1
    fi
    DEVICE="${SERIAL_DEVICES[0]}"
fi

# Prompt for credentials
read -rsp "Current enable password (blank if none): " CURRENT_ENABLE
echo
read -rsp "New enable secret: " ENABLE_SECRET
echo
read -rsp "TA SSH password: " SSH_SECRET
echo
echo
echo "Deploying target configuration:"
echo "  Hostname:      $HOSTNAME"
echo "  Serial device: $DEVICE"
echo "  TA MAC 1:      $TA_MAC_1"
echo "  TA MAC 2:      $TA_MAC_2"
echo "  Current enable password: $CURRENT_ENABLE"
echo "  New enable secret:       $ENABLE_SECRET"
echo "  TA SSH password:         $SSH_SECRET"
echo

read -rp "Continue? [y/N]: " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "DEPLOYMENT ABORTED."
    exit 0
fi

# Render config into proteted tmp file
TMP_CONFIG="$(mktemp)"
chmod 600 "$TMP_CONFIG"

cleanup() {
    rm -f "$TMP_CONFIG"
    unset CURRENT_ENABLE ENABLE_SECRET SSH_SECRET
}

trap cleanup EXIT

export HOSTNAME ENABLE_SECRET SSH_SECRET TA_MAC_1 TA_MAC_2

sed \
    -e "s|__HOSTNAME__|$HOSTNAME|g" \
    -e "s|__ENABLE_SECRET__|$ENABLE_SECRET|g" \
    -e "s|__SSH_SECRET__|$SSH_SECRET|g" \
    -e "s|__TA_MAC_1__|$TA_MAC_1|g" \
    -e "s|__TA_MAC_2__|$TA_MAC_2|g" \
    "$GOLDEN_CONFIG" > "$TMP_CONFIG"

# Cisco console automation

export DEVICE CURRENT_ENABLE TMP_CONFIG

expect <<'EXPECT_EOF'

set timeout 30
set device $env(DEVICE)
set current_enable $env(CURRENT_ENABLE)
set config_file $env(TMP_CONFIG)

puts "\nConnecting to $device..."

spawn screen $device 9600
sleep 2
send "\r"

# Reach EXEC
expect {
    -re {[^\r\n]+>\s*$} {
        send "enable\r"

        expect {
            -re {[Pp]assword:} {
                send "$current_enable\r"
                expect -re {#\s*$}
            }
            -re {#\s*$} {
            }
        }
    }

    -re {#\s*$} {
    }

    timeout {
        puts "\nERROR: Could not obtain Cisco CLI prompt."
        exit 1
    }
}

# Prevent --More-- pagination
send "terminal length 0\r"
expect -re {#\s*$}

# Normalize standalone stack to member 1
send "show switch\r"

set member 1

expect {
    -re {\*([0-9]+)\s+Master} {
        set member $expect_out(1,string)
    }
    -re {#\s*$} {
    }
}

expect -re {#\s*$}

if {$member != 1} {
    puts "\nSwitch is currently stack member $member."
    puts "Renumbering to stack member 1..."

    send "configure terminal\r"
    expect -re {\(config\)#\s*$}

    send "switch $member renumber 1\r"

    expect {
        -re {\(config\)#\s*$} {}
        -re {#\s*$} {}
    }

    send "end\r"
    expect -re {#\s*$}
    send "copy running-config startup-config\r"

    expect {
        -re {Destination filename.*\?} {
            send "\r"
            exp_continue
        }
        -re {\[OK\]} {}
        -re {#\s*$} {}
    }

    puts "Reloading switch to apply stack renumber..."
    send "reload\r"
    expect {
        -re {Proceed with reload.*confirm.*} {
            send "\r"
        }
        -re {\[confirm\]} {
            send "\r"
        }
    }

    set timeout 180

    expect {
        -re {Press RETURN to get started} {
            send "\r"
        }
        -re {Would you like to enter the initial configuration dialog.*} {
            send "no\r"
        }
        timeout {
            puts "\nERROR: Switch did not return after reload."
            exit 1
        }
    }
    sleep 5
    send "\r"

    expect {
        -re {[^\r\n]+>\s*$} {
            send "enable\r"

            expect {
                -re {[Pp]assword:} {
                    send "$current_enable\r"
                    expect -re {#\s*$}
                }
                -re {#\s*$} {}
            }
        }

        -re {#\s*$} {}
    }

    send "terminal length 0\r"
    expect -re {#\s*$}
}

# Enter global config mode
send "configure terminal\r"
expect -re {\(config\)#\s*$}

# Apply golden-config
set fh [open $config_file r]

while {[gets $fh line] >= 0} {
    set trimmed [string trim $line]

    # Ignore blanks/comments
    if {$trimmed eq ""} {
        continue
    }

    if {[string match "#*" $trimmed]} {
        continue
    }

    send -- "$trimmed\r"

    expect {
        -re {\(config[^)]*\)#\s*$} {}
        -re {#\s*$} {}
        timeout {
            puts "\nERROR while applying command:"
            puts "$trimmed"
            close $fh
            exit 1
        }
    }
}

close $fh

# Ensure back at privileged EXEC
send "end\r"
expect -re {#\s*$}

# Generate RSA Key
send "configure terminal\r"
expect -re {\(config\)#\s*$}

send "crypto key generate rsa modulus 2048\r"

expect {
    -re {Do you really want to replace them.*} {
        send "no\r"
        expect -re {\(config\)#\s*$}
    }

    -re {\[OK\]} {
        expect -re {\(config\)#\s*$}
    }

    -re {\(config\)#\s*$} {
    }

    timeout {
        puts "\nWARNING: RSA key generation did not return expected output."
    }
}

send "end\r"
expect -re {#\s*$}

# Save config
puts "\nSaving startup configuration..."
send "copy running-config startup-config\r"

expect {
    -re {Destination filename.*\?} {
        send "\r"
        exp_continue
    }

    -re {\[OK\]} {
        exp_continue
    }

    -re {#\s*$} {
    }

    timeout {
        puts "\nERROR: Timed out saving configuration."
        exit 1
    }
}

# Basic verification script
puts "\nRunning verification...\n"

send "show vlan brief\r"
expect -re {#\s*$}

send "show ip interface brief\r"
expect -re {#\s*$}

send "show port-security interface FastEthernet1/0/24\r"
expect -re {#\s*$}

send "show ip ssh\r"
expect -re {#\s*$}

puts "\nProvisioning complete."

send "exit\r"

EXPECT_EOF

echo
echo "======================================"
echo "Deployment complete."
echo "======================================"
echo "--------------------------------------"
echo
echo "Recommended manual checks:"
echo "  show switch"
echo "  show vlan brief"
echo "  show interfaces status"
echo "  show interface brief"
echo "  show port-security interface FastEthernet1/0/24"
echo "  show ip ssh"
