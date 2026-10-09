# Lab 01 Switch Deployment

This directory contains the deployment workflow for configuring switches used in the Lab 01 deployment bags.

The provisioning script applies the Lab 01 golden configuration:

- Student VLANs 10 & 20
- TA management VLAN 3
- "Parking Lot" VLAN 999
- Management SVI @ `10.0.3.2/24`
- TA-only management access on `Fa1/0/24`
- Static port-security MAC allowlist
- SSH management configuration
- Disabled Layer 3 routing
- Student port assignments
- Shutdown, or "parking" configuration for unused ports

Each Lab 01 switch is isolated from the others. This means that all switches will have the **same IP address of** `10.0.3.2`.

## Requirements

The provisioning machine must have:

- Linux
- A Cisco console cable connected to the switch
- `screen`
- `expect`

The script expects the console connection to appear as a device such as:

```txt
/dev/ttyUSB*
```

## Environment Configuration

The TA management MAC addresses are intentionally not stored in Git for security reasons.

Create a local `.env` file from the provided example [located here](.env.example).

### Credentials

Passwords are not stored in .env or in Git. When the deployment script runs, it will intentionally prompt the user for:

- current enable password, if one exists
- new enable secret
- TA SSH password

## Usage

Make the provisioning script executable:

```bash
chmod +x provision-switch.sh
```

Then run the script with the desired hostname:

```bash
./deploy-switch.sh BG01-SW02
```

## Provisioning Process

The script will:

1. Load the authorized TA MAC addresses from `.env`
2. Detect the connected serial console device
3. Prompt for required credentials
4. Connect to the switch through the console port
5. Normalize the switch to stack member `1` if needed
6. Apply [golden-config.txt](golden-config.txt)
7. Insert defined hostname from shell prompt
8. Insert TA management MAC addresses
9. Configure `enable` & `SSH` secrets
10. Generate a unique 2048-bit RSA key
11. Save running configuration to startup configuration
12. Run basic verification tests

## Security Notes

The `.env` file contains hardware identifiers and is intentionally excluded from Git tracking.

Passwords are never stored in the repository and are entered interactively during deployment.

Each physical switch generates is own RSA host key rather than one shared key across all switches.

The Lab 01 switches are designed to remain isolated from the UC production network.
