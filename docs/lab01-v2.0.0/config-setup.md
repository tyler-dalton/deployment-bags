# Lab 01 Configuration Setup Documentation

This document will cover the configuration of the deployment bags for lab01. The documentation will consist of configuring two student VLANs, a management VLAN, and blocking access to port 24 for all MACs except TA MACs to use the port as a failsafe management ethernet connection.

For more information regarding the architecture of Lab 01, please see the [Lab 01 Architecture document](overview.md) located next to this file.

## Discovery, & Connection to PuTTY or Switch

Regarding this documentation, it will follow a configuration for switch connection via the terminal, but PuTTY can also be used in this case.

Find the serial device name:

From the terminal, run `ls /dev/ttyUSB*` for Unix-based systems. This command will print the interface of the serial connection in order to receive console connection.

![TTY discovery from the terminal](/media/lab01/tty.png)

Connect to the switch:

Using this information, connection can either be established from the terminal or via a serial console such as PuTTY. If connecting via the terminal, run `sudo screen /dev/ttyUSB0 9600`, using the command output for the number following USB. For PuTTY, click the serial button, type the path listed above, then click connect.

![Switch configuration welcome](/media/lab01/sw-entry.png)

From the terminal, click entire a few times. Eventually a command line with the hostname of the switch should appear on the screen. In this example, the hostname resembles `BG01-SW01`. This means the terminal is now connected to the switch.

### Entering Executive Mode

Next, in order to make any changes, the switch interface needs to be in privileged/EXEC mode. Execute this by running a simple `enable` command.

![Move into EXEC mode on the switch](/media/lab01/sw-enable.png)

When entering EXEC mode, the switch will prompt for a password. If you do not know the password, please see Tyler. Entrance into EXEC mode is confirmed by seeing the pound (#) key next to the hostname. In this configuration, `BG01-SW01#`

## Set Hostname & Enable Secret

Next, the hostname and secret will need to be set. The hostname for this switch is already configured, so this section may look interesting. The concept is: hostname `HOSTNAME`.

```cisco.ios
configure terminal
  hostname BG01-SW01
  enable secret <SECRET_NAME>
```

![Cisco IOS commands to set hostname & secret](/media/lab01/hostname-secret.png)

## VLAN Creation

For the sake of Lab 01, four VLANS will be configured. The VLAN numbers and their purposes are as follows:

- VLAN 10: Student VLAN #1
- VLAN 20: Student VLAN #2
- VLAN 3: TA Management VLAN
- VLAN 999: Extra security measure for bricked ports

```cisco.ios
vlan 10
  name LAB10
exit
vlan 20
  name LAB20
exit
vlan 3
  name TA-MAN
exit
vlan 999
  name BRICK
exit
```

![Cisco IOS commands to create four VLANS](/media/lab01/vlan-create.png)

VLAN 99 is commonly used as a management VLAN. With that being said, it is almost too predictable. In order to prevent against unwanted intrusion, the bags will use a more unique VLAN, which will be `VLAN 3`.

### Verify Creation of VLANs

```cisco.ios
show vlan brief
```

![Terminal output confirming Cisco VLAN creation](/media/lab01/vlan-con.png)

Due to these screenshots being taken after setup, this output will not look exactly as expected. The expected output should be focused on the creation of the VLANS, as depicted inside of the red box.

## Configure TA Management SVI

Configuring a management SVI (Switched Virtual Interface) inside of the switch will create a logical Layer 3 interface assigned to a specific VLAN that allows the admins to remotely manage the switch.

```cisco.ios
configure terminal
  interface Vlan3
    description TA MGMT SVI
    ip address 10.0.3.2 255.255.255.0
    no shutdown
  exit
end
```

![Cisco IOS commands to configure management SVI](/media/lab01/svi-config.png)

Configuring the management SVI with an IP address of `10.0.3.2` means that ssh connection to the switch will happen at the IP address `10.0.3.2`. This is to keep things in-line for the possible addition of a router/gateway, which would then host the `10.0.3.1` address.

### Verify Creation & Configuration of MGMT SVI

```cisco.ios
show ip interface brief
```

![Terminal output confirming SVI creation](/media/lab01/svi-con.png)

Expected output is now seeing the IP Address `10.0.3.2` assigned to `Vlan3`. At this point in time, copy and save the current running and startup configuration: `copy running-config startup-config`. When prompted for destination filename, press enter.

## Port 24 - Management

```cisco.ios
configure terminal
  interface FastEthernet1/0/24
    description ** TA MGMT **
    switchport mode access
    switchport access vlan 3
    switchport nonegotiate
    spanning-tree portfast
    spanning-tree bpduguard enable
  exit
end
```

![Cisco IOS commands to configure port 24 as management port](/media/lab01/p24-config.png)

Confirm with:

```cisco.ios
show interface status
show vlan brief
```

show interface status: Expected output

![Cisco IOS command output confirming port 24 management access](/media/lab01/p24-man-con.png)

show vlan brief: Expected output

![Cisco IOS command output port 24 assigned to VLAN 3](/media/lab01/p24-vlan-con.png)

## Port Security VLAN 3

In order to keep the environment as secure as possible, only specifically defined MAC addresses will have the ability to connect into Fa1/0/24:

```cisco.ios
configure terminal
  interface FastEthernet1/0/24
    switchport port-security
    switchport port-security violation restrict
    switchport port-security maximum 2
    switchport port-security mac-address AAAA.BBBB.CCCC
    switchport port-security mac-address FFFF.GGGG.HHHH
  exit
end
```

![Cisco IOS commands to allow mac-addresses through port 24](/media/lab01/mac-allow.png)

For security reasons, MAC address configuration has been omitted for documentation.

> Both `AAAA.BBBB.CCCC` and `FFFF.GGGG.HHHH` should be replaced with the MAC addresses needed. Typically, MAC addresses are displayed in the standard colon format. **Take the 48-bit colon format and regroup to three blocks of four hex digits**. This is the formatting Cisco prefers and uses.

Confirm with:

```cisco.ios
show port-security interface FastEthernet1/0/24
```

![Cisco IOS command confirming MAC allow list configuration](/media/lab01/mac-allow-con.png)

Expected output:

- `Maximum MAC Addresses`: 2
- `Total MAC Addresses`: 2
- `Configured MAC Addresses`: 2

## Student Port --> VLAN Configuration

As mentioned in the [Lab 01 Overview](overview.md), and consistent with the configuration above, two student VLANs will be configured:

```cisco.ios
configure terminal

# This will configure ports 1-10 to VLAN 10
interface range FastEthernet1/0/1 - 10
  description LAB-VLAN10
  switchport mode access
  switchport access vlan 10
  switchport nonegotiate
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
exit

# Administratively set ports 11 & 12 down
interface range FastEthernet1/0/11 - 12
  description ** ADMIN DOWN **
  shutdown
exit
```

![Terminal commands to set student VLAN 10](/media/lab01/ports-vlan10.png)

As seen from the screenshot, there is confirmation that ports 11 & 12 have been set down. Cisco logs reported both ports set administratively down. Next, follow relatively the same steps to configure ports 13-22 for `vlan 20`:

```cisco.ios
# This will configure ports 13-22 to VLAN 20
interface range FastEthernet1/0/13 - 22
  description LAB-VLAN20
  switchport mode access
  switchport access vlan 20
  switchport nonegotiate
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
exit

# Administratively set port 23 down
interface FastEthernet1/0/23
  description ** ADMIN DOWN **
  switchport mode access
  switchport access vlan 999
  shutdown
exit

end
```

![Terminal commands to set student VLAN 20](/media/lab01/ports-vlan20.png)

### Student VLAN Verification

Verify the VLAN configuration has now been applied with two commands:

```cisco.ios
show vlan brief
show interface status
```

VLAN verification:

![show vlan brief Cisco IOS command output](/media/lab01/portCon-vlan.png)

Interface verification:

![show interface status Cisco IOS command output](/media/lab01/portCon-int.png)
