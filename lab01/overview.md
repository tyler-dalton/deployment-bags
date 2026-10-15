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
| `Ports 1-10` | VLAN 1 (student VLAN) |
| Ports 11-24 | VLAN 999 (administratively down) |
| Management | `SSH restricted to authorized TA devices` (via MAC) |
| Endpoints | `University provided laptops` |
| Connectivity | `No production network uplink. Endpoint RJ45 -> Ethernet -> Switch` |

All deployment bags share identical configuration and IP addressing schema. Ensuring consistency across each bag makes management and documentation considerably easier. Due to the deployment bag networks being isolated, there will be no posed confliction between the bags.
