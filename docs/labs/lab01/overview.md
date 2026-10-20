# Lab 01 v3.0.0 - Deployment Architecture Overview

## Overview

Lab 01 introduces students to the physical networking landscape. IPv4 addressing and basic connectivity troubleshooting will be covered in this lab using real networking equipment brought into the classroom via the deployment bags.

The lab will consist of `two deployment bags` that have the ability to support `4 isolated lab groups`. Each group will have one switch that can connect **up to 10 student endpoints**. There is the possibly to use up to 23 student endpoints per group, but to ensure best practice security measures, port availability is intended to be limited to only what may be needed (cap student class of 40). No routing or student-side switch configuring is needed for this lab.

## Network Architecture

| Component | Configuration |
| --- | --- |
| Deployment Bags | 2 Identical Configurations |
| Deployment Groups | 4 Identical Configurations (2 groups per bag) |
| Network | `10.0.0.0/24` |
| Subnet Mask | `255.255.255.0` |
| Switch IP | `10.0.0.1` |
| `Ports 1-3` | VLAN 1 (student VLAN) |
| Ports 4-22 | VLAN 999 (administratively down) |
| Port 23 | VLAN 1 (TA management) |
| Port 24 | VLAN 1 (game server) |
| Management | `SSH restricted to authorized TA devices` (via MAC) |
| Endpoints | `University provided laptops` |
| Connectivity | `No production network uplink. Endpoint RJ45 -> Ethernet -> Switch` |

All deployment bags share identical configuration and IP addressing schema. Ensuring consistency across each bag makes management and documentation considerably easier. Due to the deployment bag networks being isolated, there will be no posed confliction between the bags.

## Student Workflow

1. **Physical Deployment**: Establish power to the bag, connect endpoints to the switch via Ethernet.
2. **IPv4 Configuration**: Assign unique static IP addresses within the `10.0.0.0/24 network`. No default gateway is required.
3. **Switch Connectivity**: Execute `ping 10.0.0.1` to verify communication upstream to the switch.
4. **Peer-to-Peer (P2P) Connectivity**: Attempt ICMP communication between endpoints. Step is intentionally designed to fail due to Windows Firewall rules.
5. **ARP Inspection**: Execute `arp -a` to inspect resolved IP-to-MAC address mappings. Despite a failed ICMP request, a successful ARP command demonstrates local address discovery.

## Admin Configuration

TA's are responsible for deploying, securing, and restoring switch configuration as needed. Students receive **no switch configuration privileges. Each deployment bag must be restored to its documented baseline between lab sessions.

## Learning Objectives

Students will demonstrate learning in:

* Physical LAN assembly
* Static IPv4 addressing
* Switch connectivity testing
* MAC address resolution through ARP
* Knowledge of distinction between Layer 2 connectivity & successful ICMP communication

## Administrative Requirements

* All four deployment bags must maintain **identical baseline configurations**
* Switch management access is restricted to **authorized TA devices**
* Students must not modify switch configurations
* Switch configurations must be backed up and restored to the documented baseline between lab sessions

## Expected Outcomes

Upon completion, students should have:

* Successfully established a LAN network
* Configured endpoint addressing
* Verified switch connectivity
* Inspected ARP entries to neighboring devices

Failed peer-to-peer ICMP requests are acceptable when caused by endpoint firewall restrictions, provided ARP resolution succeeds.
