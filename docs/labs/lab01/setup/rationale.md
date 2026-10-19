# Lab 01 Rationale Explanations

## Hostname Configuration

The main goal for the hostnames is to leverage the unique inventory ID, while also giving administrators an exact location of the hardware. The `InventoryID` can be found on any piece of equipment, with a white label.

We add the `bag UID` in front of the `InventoryID` to depict that exact location. The naming convention is short, easy to remember, and can be used for multiple use cases such as troubleshooting & documentation.

**Current hostnames**:

```text
# Cisco 3750
BG01-SW01
# Cisco 2960
BG01-SW02
# Juniper EX3300 1
BG02-SW03
# Juniper EX3300 2
BG02-SW03
```

## Disable HTTP-Based Management

**HTTP-based management is disabled to reduce unnecessary management services and the device’s attack surface**.

HTTP transmits credentials and configuration data in cleartext, exposes an additional listening service that is frequently targeted, and is not required when more secure management options (such as SSH or console access) are available. Disabling it eliminates an unneeded attack vector and aligns with least-functionality hardening practices.

## VLAN Schema

The Lab 01 network utilizes a three-VLAN architecture to provide a balance between simplicity, security, and administrative control.

### VLAN 1 — Student Network (Default)

The default VLAN is retained for student-facing interfaces to minimize configuration complexity and allow students to focus on foundational networking concepts.

### VLAN 10 — Management

A dedicated management VLAN separates administrative traffic from student-facing network traffic. This allows instructors and teaching assistants to manage network equipment independently of student configurations, reducing the risk of accidental management disruptions.

VLAN separation also provides a foundation for implementing additional access controls as the lab environment evolves.

### VLAN 999 — Unused Ports

All unused switch interfaces are assigned to VLAN 999, an isolated VLAN with no active hosts or routed connectivity, and administratively disabled. This reduces the risk of unauthorized network access through unused physical ports.

## Disabled Ports

Each deployment group is designed to support one of four student groups, with **20 laptops distributed evenly across the groups**. This results in five student endpoints per switch, requiring only interfaces `Fa0/1-5` to be enabled.

All remaining unused interfaces are assigned to `VLAN 999` and administratively disabled. This minimizes unnecessary exposure, prevents unauthorized or accidental connections, and reduces the risk of unintended changes to the lab topology.

By enabling only the interfaces required for the established group size, the configuration follows the **principle of least privilege** while maintaining a consistent, secure, and repeatable baseline across all four deployment bags.

## Access Port Configuration

Interface access ports are explicitly configured as access ports to ensure they carry traffic only for their designated VLAN. Dynamic Trunking Protocol (DTP) negotiation is disabled to prevent connected devices from negotiating trunk connections.

**PortFast** is enabled to allow student endpoints to transition immediately into the forwarding state, reducing connection delays during device startup and reconnection.

**BPDU Guard** is enabled as an additional protective measure. If a student connects a switch or another device transmitting Bridge Protocol Data Units (BPDUs), **the interface automatically enters an error-disabled state**. This helps prevent unintended changes to the network's spanning-tree topology and protects the shared lab environment from accidental misconfigurations.

Together, these configurations establish a consistent and controlled access-layer environment.

## TA Management Interface

Port `Fa0/23` is reserved exclusively for authorized teaching assistants and instructors to provide a **dedicated physical connection for network administration**. Unlike student-facing interfaces which operate on `VLAN 1`, the management interface is assigned to `VLAN 10` to logically separate administrative traffic from student activity.

This separation reduces the risk of students accidentally interfering with network management and **establishes a foundation for additional security controls**. MAC-based port security will restrict which devices can connect through the management interface, while SSH access restrictions will limit administrative access to authorized management hosts.

## Student port MAC-based Security

Each student-facing port `(fa0/1-3)` is restricted to one designated laptop using a statically assigned MAC address.

The `maximum 1` setting limits each port to a single authorized MAC address, while the static assignment ensures that only the designated laptop can use that port. This prevents unauthorized access and connection to student ports, maintaining a consistent network topology across deployment bags.

The `restrict` violation drops unauthorized traffic without disabling the port, minimizing TA intervention during labs.

### **Alternative Considered: MAC Address Whitelisting**

A shared whitelist of ~20 student endpoints was considered to allow authorized devices to connect through any student-facing port.

However, implementing centralized MAC-based authentication would require additional infrastructure such as **FreeRADIUS and MAC Authentication Bypass**, which is considered outside of the project scope currently.

Static port assignments were selected for their simplicity and ease of maintenance. Centralized MAC authentication remains a potential future enhancement to provide greater flexibility without sacrificing access control.
