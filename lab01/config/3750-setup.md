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


