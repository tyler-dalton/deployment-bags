# Lab01 Ver. 2.0.0

This marks the refactor of Lab01, moving towards the broadcast lab as mentioned on 10/07.

## Architecture

```txt
                  LAB 01 — SWITCHED LAN
                 NO ROUTER / NO INTERNET
                           │
              ┌────────────┴────────────┐
              │     Managed Switch      │
              │                         │
              │   VLAN 10    VLAN 20    │
              │                         │
              └─────┬───────────┬───────┘
                    │           │
                Ports 1–12     Ports 13–24
                  VLAN 10         VLAN 20
              192.168.10.0/24  192.168.20.0/24
                    │                 │
               ┌────┼────┐       ┌────┼────┐
              PC   PC   PC       PC   PC   PC
```

Overall, this is the structure that we are searching for in v2.0.0. Each member of the class will connect into the switch via ethernet, configure their CIDR address, and run a few minor connectivity tests to prove segmentation.

The Lab will consist of **TWO VLAN's**. We will be using the 10 and the 20 VLAN:

VLAN 10 - `10.0.10.0/24`
VLAN 20 - `10.0.20.0/24`

Since there is now five switches, students will be split up amongst the 5, then evenly split into groups for VLAN 10 & 20. Students should *not* configure the VLAN on their laptop. We will configure each switch port as an access port on each VLAN. The endpoints will send ordinary untagged traffic to the switch.

### Port Configuration

Ports `1-12` will access VLAN 10, ports `13-23` will access VLAN 20. Port 24 will be left as a failsafe management port if needed.

## TLDR

| VLAN | Switch Ports | Subnet | Student Addresses |
|---|---|
| VLAN 10 | `Fa0/1-Fa0/12` | 10.0.10.0/24 | `10.0.10.10-21` |
| VLAN 20 | `Fa0/13-Fa0/23` | 10.0.20.0/24 |`10.0.20.10-20` |

## Student Configuration

For the lab, each student will ideally statically configure:

* IP address
* Subnet mask

For example:

```txt
IP address: 10.0.10.11/24
Subnet mask: 255.255.255.0
Gateway: <blank>
DNS: <blank>
```

## Lab Structure

The lab will be broken into 4 parts:

1. Establish wired connection
2. Connectivity to other devices, same VLAN, same subnet
3. Swap ethernet cords, do not change IP, watch pings still fail
4. Finally, swap the IP, see ping go through

## TO NOTE

One issue we may see arise is with our Windows folks. By default, IMCP echo requests in are typically denied from the firewall. Currently seeking advice from Emrah with how to address this. Unsure if the correct solution is to have every student allow this firewall rule, unsure if we can have them all do that for a lab. (legally, ethically, etc.)
