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

## Student VLAN Configuration

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
