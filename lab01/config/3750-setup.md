# Lab 01 - Cisco Catalyst 3750 Configuration

| Property | Value |
| --- | --- |
| Switch | Cisco Catalyst WS-C3750-24PS-S |
| InventoryID | SW01 |
| Hostname | BG01-SW01 |
| IOS | 12.2(55)SE10 |
| Image | C3750-IPServicesK9-M |
| Access Interfaces | 24 FastEthernet |
| Uplink Interfaces | 2 GigabitEthernet |
| Management | SSHv2, restricted |

## Phase 1 - Base System Configuration

The start of the setup will cover the `switch's identity and fundamental operating settings`. Following the base configuration, this documentation will cover the interface configuration, management security, and configuration-storage procedure for the **Cisco Catalyst 3750**.

### 1.1 Configure Switch Identity

Each switch will receive a unique hostname for identification during admin and troubleshooting workflows. The hostname will differ from the InventoryID by also including the bag in which the switch resides.

The naming convention is `BG##-SW##`, where `BG` identifies the deployment bag number, and `SW` defines the switch number. That way we will have an aggregation of bag location & switch number to quickly identify the switch in question.

**Enable the switch and enter global configuration mode**:

```cisco
enable
configure terminal
```

**Apply the following configuration commands**:

```cisco
hostname BG01-SW01
no ip routing
no ip http server
no ip http secure-server
service password-encryption
no service pad
end
```

![Cisco 3750 Identity configuration console output](/lab01/media/3750-setup/identity.png)

Although the Catalyst 3750 supports Layer 3 routing, routing is disabled for Lab 01 because all student endpoints reside within a single subnet. HTTP-based management is also disabled to reduce unnecessary management services and the device's attack surface.

> `service password-encryption` obscures applicable plaintext passwords within the configuration. This provides protection against casual exposure but is not a substitute for secure password hashing or SSH authentication.

### 1.2 Verify Base Configuration

```cisco
show running-config | include hostname|ip routing|ip http|service
```

![Base switch configuration verification](/lab01/media/3750-setup/base-confirm.png)

## Phase 2 - VLAN and Interface Provisioning

### 2.1 Configure the VLAN baseline

`VLAN 1` will serve as the flat student VLAN. `VLAN 999` will isolate unused ports and provide an additional security best-practice method.

> Students **will not** configure or interact with VLANs for the duration of lab 01.

Enter global configuration mode and `create VLAN 999`:

```cisco
configure terminal

vlan 999
  name BRICK
exit
```

![create VLAN 999](/lab01/media/3750-setup/vlan999-create.png)

> VLAN 1 is already present by default with the base configuration of Cisco switches. There is no need for a VLAN 1 to be created

### 2.2 Configure student-facing Interfaces

Ports `Fa1/0/1-10` provide connectivity for student endpoints. Configuring the first ten ports will give the lab **40 possible student connections**. The remaining ports will be moved to `VLAN 999` and shut down. This is done in order to keep unnecessary unused ports inaccessible.

```cisco
interface range FastEthernet1/0/1 - 10
  description LAB01-STUDENT
  switchport mode access
  switchport access vlan 1
  switchport nonegotiate
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
exit
```

![assign interfaces 1-10 standard access port control](/lab01/media/3750-setup/1-10-int-config.png)

These interfaces will operate as **standard access ports**. The ports prevent trunk negotiation and keep all student endpoints within the same broadcast domain.

`PortFast` allows connected endpoints to reach the forwarding state without the normal spanning-tree startup delay. `BPDU Guard` helps protect the LAN from switching loops and external switches.

### 2.3 Disable Unused Interfaces

All unused FastEthernet ports and both GigabitEthernet uplinks will be administratively disabled.

```cisco
interface range FastEthernet1/0/11 - 23
 description ADMIN-DOWN
 switchport mode access
 switchport access vlan 999
 shutdown
exit

interface range GigabitEthernet1/0/1 - 2
 description ADMIN-DOWN
 switchport mode access
 switchport access vlan 999
 shutdown
exit
```

![Disabling unused interfaces](/lab01/media/3750-setup/disable-int.png)

Placing unused interfaces on `VLAN 999` **isolates them from the student LAN**. Shutdown prevents those interfaces from establishing network connectivity. This is especially important because deployment bags **must remain disconnected from UC's production infrastructure**.

### 2.4 Reserve the TA Management Interface

Port `Fa1/0/24` will provide dedicated physical access for authorized TAs, with several access control methods implemented such as MAC-based authorization which will be covered when configuring the management SVI.

```cisco
interface FastEthernet1/0/24
  description TA-MAN
  switchport mode access
  switchport access vlan 1
  switchport nonegotiate
  spanning-tree portfast
  spanning-tree bpduguard enable
  no shutdown
exit
end
```

![Configuration of port 24 management access](/lab01/media/3750-setup/p24-man-config.png)

Port 24 `shares VLAN 1` because the architecture uses a single subnet. MAC-based port security and additional SSH restrictions will be configured in Phase 3.

At this stage, port 24 is **not yet restricted**.

### 2.5 Verify Interface Configuration

Run:

```cisco
show vlan brief
show interface status
show running-config | begin interface FastEthernet1/0/24
```

**Expected output**:

![VLAN assignment verification](/lab01/media/3750-setup/verify-vlan.png)

![Interface assignment verification](/lab01/media/3750-setup/verify-int.png)

![Port 24 verification](/lab01/media/3750-setup/verify-p24.png)
