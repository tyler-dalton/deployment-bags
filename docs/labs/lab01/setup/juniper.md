# Lab 01 - Juniper EX3300 PoE+ Configuration

| Property | Value |
| --- | --- |
| Switch | Juniper EX3300-24P |
| Inventory IDs | SW03, SW04 |
| Hostnames | BG02-SW03, BG02-SW04 |
| JunOS Version | 12.3R6.6 |
| Chassis Serial # | GE0214504728 |
| Access Interfaces | 24 GigabitEthernet |
| Uplink Interfaces | 4 10GE SFP+ |
| Management | SSHv2, restricted |

## Phase 1 - Base System Configuration

The start of the setup will cover the `switch's identity and fundamental operating settings`. Following the base configuration, this documentation will cover the interface configuration, management security, and configuration-storage procedure for the **Juniper EX3300**.

### 1.1 Configure Switch Identity

Each switch will receive a unique hostname for identification during admin and troubleshooting workflows. The hostname will differ from the InventoryID by also including the bag in which the switch resides.

The naming convention is `BG##-SW##`, where `BG` identifies the deployment bag number, and `SW` defines the switch number. That way we will have an aggregation of bag location & switch number to quickly identify the switch in question.

Dependant on which switch it being set up, **use the hostname `BG02-SW03` or `BG02-SW04`:

```juniper
cli
configure
set system host-name BG02-SW03
set system domain-name dep-bags.local
delete system services web-management
```

![Configure hostname](../media/juniper/hostname.png)

> [!NOTE]
> The `delete system services web-management` command is needed only if that stanza exists; a message that the statement does not exist is harmless. Likewise, do not enable Telnet. JunOS uses password hashes rather than Cisco `service password-encryption`, and no Cisco `enable secret` equivalent is needed for a `super-user` account. Routing is not configured for Lab 01; do not configure IP routing on additional VLAN interfaces or a default route.

### 1.2 Configure Root Authentication

**JunOS requires root authentication to be configured before the first configuration commit can succeed**. Unlike Cisco IOS, where administrative privileges are controlled through enable mode, JunOS uses user accounts with assigned login classes.

**While in configuration mode**:

```juniper
set system root-authentication plain-text-password
```

When prompted, enter and confirm a strong password. The password will not be displayed while typing.

> [!IMPORTANT]
> Root authentication is mandatory on an initially unconfigured Juniper EX3300. Attempting to commit without it will produce the error `Missing mandatory statement: 'root-authentication'`.

---

> [!CAUTION]
> Do not include plaintext credentials or password hashes in published documentation. Store administrative credentials using the project's approved secure credential-storage process.

### 1.3 Verify Base Configuration

Before committing, **inspect the pending system configuration**:

```juniper
show system host-name
show system domain-name
show system services
show | compare
```

**Expected output**:

![Verify system configuration](../media/juniper/verify-hostname.png)

**Verify that**:

* The `hostname` matches the assigned switch: `BG02-SW03` or `BG02-SW04`
* The domain name is `dep-bags.local`
* HTTP and HTTPS web management services are not enabled
* Root authentication has been configured

**Validate the pending configuration**:

```juniper
commit check
```

**Expected output**:

```juniper
configuration check succeeds
```

If the configuration is correct, confirm the commit:

```juniper
commit
```

**Expected output**:

```juniper
commit complete
```

![First commit of hostname](../media/juniper/commit1.png)

> [!NOTE]
> Unlike Cisco IOS, **JunOS does not maintain independently edited running and startup configurations**. Changes are made to a candidate configuration and activated using commit. Successfully committed changes persist across a reboot.

## Phase 2 - VLAN and Interface Provisioning

Now that Phase 1 is complete, we'll configure the EX3300's Layer 2 switching environment. We'll follow the same architecture as your Cisco 3750

| Purpose | Juniper EX3300 Interfaces | VLAN |
| --- | --- | --- |
| Student access | `ge0/0/0 - 9` | 1 |
| Disabled / Bricked | `ge0/0/10 - 22` | 999 |
| TA management | `ge0/0/23` | 1 |
| Disabled uplinks | `Four SFP+` | 999 where applicable |

### 2.1 Configure VLAN Baseline

`VLAN 1` serves as the primary student `LAN for Lab 01`. `VLAN 999`, named `BRICK`, isolates unused switch interfaces from the student network. **Both VLANs must remain local to the deployment bag**, without any connection to the UC production infrastructure.

**Create and verify VLAN 999**:

```juniper
set vlans BRICK vlan-id 999
show vlans
show | compare
```

![VLAN 999 configuration](../media/juniper/vlan999.png)

**Validate and commit**:

```juniper
commit check
commit
```

**Confirm VLAN 999 exists**:

```juniper
run show vlans
```

![run show vlans](../media/juniper/show-vlans1.png)

Verify that `BRICK` is present with `VLAN ID 999`. The VLAN does not need active interfaces yet; those will be assigned in Section 2.3.

> [!NOTE]
> Students will not configure VLANs during Lab 01. **VLAN 999 is reserved for administratively disabled interfaces** and should not be assigned to student endpoints.

### 2.2 Configure Student-Facing Interfaces

Now we'll configure the **first 10 Gigabit Ethernet interfaces** on the Juniper EX3300-24P for student connectivity.

These interfaces correspond to Fa1/0/1–10 on your Cisco Catalyst 3750. They will operate as standard Layer 2 access ports on VLAN 1, with Rapid Spanning Tree Protocol (RSTP) protection.

#### 2.2.1 Configure Access Ports

**Create an *interface range* to avoid configuring all ten ports individually**.

```juniper
set interfaces interface-range STUDENTS member-range ge-0/0/0 to ge-0/0/9
set interfaces interface-range STUDENTS description LAB01-STUDENT
set interfaces interface-range STUDENTS unit 0 family ethernet-switching port-mode access
set interfaces interface-range STUDENTS unit 0 family ethernet-switching vlan members default
```

**Verify pending configuration**:

```juniper
show interfaces interface-range STUDENTS
show | compare
```

**Expected output**:

![Student interface verification](../media/juniper/create-student-vlan.png)

#### 2.2.2 Configure RSTP Edge Ports

Cisco's `spanning-tree portfast` is replaced by the JunOS RSTP `edge` designation:

```juniper
set protocols rstp interface ge-0/0/0 edge
set protocols rstp interface ge-0/0/1 edge
set protocols rstp interface ge-0/0/2 edge
set protocols rstp interface ge-0/0/3 edge
set protocols rstp interface ge-0/0/4 edge
set protocols rstp interface ge-0/0/5 edge
set protocols rstp interface ge-0/0/6 edge
set protocols rstp interface ge-0/0/7 edge
set protocols rstp interface ge-0/0/8 edge
set protocols rstp interface ge-0/0/9 edge
```

Edge ports can transition directly into forwarding when connected to student endpoints, avoiding the usual spanning-tree startup delay.

#### 2.2.3 Enable BPDU Protection

```juniper
set protocols rstp bpdu-block-on-edge
```

This protects edge interfaces against unexpected BPDU traffic.

> [!IMPORTANT]
> The command operates globally on RSTP edge interfaces, not just the ten student ports. If an edge interface receives a BPDU, JunOS can block that interface to protect against an unintended switching loop. Recovery behavior should be documented and tested before deployment.

**Verify RSTP configuration**:

```juniper
show protocols rstp
show | compare
```

![confirm RSTP](../media/juniper/confirm-rstp.png)

![compare RSTP changes](../media/juniper/compare-rstp.png)

#### 2.2.4 Validate & Commit

```juniper
commit check
commit
```

#### 2.2.5 Verify Operational Configuration

```juniper
run show ethernet-switching interfaces
run show interfaces terse
```

**Verify the following**:

* Interfaces `ge-0/0/0` through `ge-0/0/9` are configured as access ports in VLAN 1
* All ten interfaces have the `LAB01-STUDENT` description
* RSTP identifies the student-facing interfaces as edge ports
* BPDU protection is configured
* No student-facing interface is administratively disabled

![Switching interfaces](../media/juniper/confirm-int.png)

![terse1](../media/juniper/terse1.png)

![terse2](../media/juniper/terse2.png)

### 2.3 Disable Unused Interfaces

**Create an interface range**:

```juniper
set interfaces interface-range UNUSED-PORTS member-range ge-0/0/10 to ge-0/0/22
set interfaces interface-range UNUSED-PORTS description ADMIN-DOWN
set interfaces interface-range UNUSED-PORTS unit 0 family ethernet-switching port-mode access
set interfaces interface-range UNUSED-PORTS unit 0 family ethernet-switching vlan members BRICK
set interfaces interface-range UNUSED-PORTS disable
```

**Verify the pending configuration**:

```juniper
show interfaces interface-range UNUSED-PORTS
show | compare
```

![confirm unused ports](../media/juniper/confirm-brick.png)

**Validate and commit**:

```juniper
commit check
commit
```

**Verify disabled interfaces**:

```juniper
run show interfaces terse | match ge-0/0/1
run show interfaces terse | match ge-0/0/2
run show vlans
run show ethernet-switching interfaces
```

The first two commands match interfaces beginning with `ge-0/0/1` and `ge-0/0/2`, including the unused ports. They are convenient for checking the range, although `ge-0/0/2` also matches student port 3.

![verify disable interfaces1](../media/juniper/disable1.png)

![verify disable interfaces2](../media/juniper/disable2.png)

**Disable unused SFP+ uplink interfaces**:

```juniper
set interfaces ge-0/1/0.0 description ADMIN-DOWN
set interfaces ge-0/1/0.0 disable
set interfaces ge-0/1/1.0 description ADMIN-DOWN
set interfaces ge-0/1/1.0 disable
```

### 2.4 Reserve the TA Management Interface

Physical port 24 (`ge-0/0/23`) will serve as the dedicated TA management connection, equivalent to `Fa1/0/24` on the Cisco Catalyst 3750.

The interface will remain in `VLAN 1` because Lab 01 uses a single subnet. Additional management security, including SSH restrictions and MAC-based authorization, will be configured in Phase 3.

**Configure the management port**:

```juniper
set interfaces ge-0/0/23 description TA-MAN
set interfaces ge-0/0/23 unit 0 family ethernet-switching port-mode access
set interfaces ge-0/0/23 unit 0 family ethernet-switching vlan members default
```

**Configure RSTP protection**:

```juniper
set protocols rstp interface ge-0/0/23 edge
```

The global `bpdu-block-on-edge` setting configured earlier will also protect this interface.

**Verify the pending configuration**:

```juniper
show interfaces ge-0/0/23
show protocols rstp
show | compare
```

![management port compare](../media/juniper/man-compare.png)

**Validate and commit**:

```juniper
commit check
commit
```

**Verify operational configuration**:

```juniper
run show interfaces terse ge-0/0/23
run show ethernet-switching interfaces
run show configuration interfaces ge-0/0/23
run show configuration protocols rstp
```

![running config man port1](../media/juniper/man-confirm1.png)

![running config man port2](../media/juniper/man-confirm2.png)

| Component | Expected Result |
| --- | --- |
| Interface | `ge-0/0/23` |
| Description | `TA-MAN` |
| Administrative State | Up |
| VLAN | `default` (VLAN 1) |
| Port Mode | Access |
| RSTP | Edge |
| BPDU Protection | Enabled |

> [!IMPORTANT]
> The TA port is not yet secured against unauthorized MAC addresses or SSH access. Do not treat the switch as deployment-ready until Phase 3 is complete.

### 2.5 Verify Interface Configuration

The Juniper EX3300 should now have **ten active student-facing interfaces, thirteen administratively disabled interfaces, one reserved TA management interface, and disabled SFP+ uplinks**.

**Verify VLAN assignments**:

```juniper
run show vlans
run show ethernet-switching interfaces
```

![VLAN confirmation](../media/juniper/2-5-vlan.png)

**Expected results**:

* VLAN `default` uses `VLAN ID 1`
* VLAN `BRICK` uses `VLAN ID 999`
* Student interfaces `ge-0/0/0` through `ge-0/0/9` belong to `default`
* TA interface `ge-0/0/23` belongs to default
* Disabled interfaces `ge-0/0/10` through `ge-0/0/22` are configured for `BRICK`

**Verify interface status**:

```juniper
run show interfaces terse | match ge-0/0/
```

![interface confirmation](../media/juniper/2-5-int.png)

| **Interface(s)** | **Expected Admin** | **Expected Link** |
| --- | --- | --- |
| `ge-0/0/0-9` | up | up or down |
| `ge-0/0/10-22` | down | down |
| `ge-0/0/23` | up | up or down |

An administratively enabled interface with no Ethernet cable connected will normally show `up/down`.

**Verify the unused interface configuration**:

```juniper
show interfaces interface-range UNUSED-PORTS
```

![unused port confirmation](../media/juniper/2-5-unused.png)

**Verify TA management interface**:

```juniper
run show configuration interfaces ge-0/0/23
run show configuration protocols rstp
```

![TA management confirmation](../media/juniper/2-5-man.png)

**Verify uplink isolation**:

```juniper
run show interfaces terse | match "ge-0/1/|xe-0/1/"
run show chassis hardware
```

![disabled uplink confirmation](../media/juniper/2-5-uplink.png)


