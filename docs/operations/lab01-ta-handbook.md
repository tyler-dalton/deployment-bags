# Lab 01 Instructor and TA Runbook

This runbook explains how to prepare, operate, verify, and restore a Lab 01
deployment bag. It is written for instructors and teaching assistants. Students
should use the [Lab 01 student guide](../labs/lab01/student-docs.md) instead.

## 1. Lab topology

Each isolated lab network uses `10.0.0.0/24`:

| Device | Address | Purpose |
| --- | --- | --- |
| Switch management SVI | `10.0.0.1` | Optional TA switch management |
| Raspberry Pi game server | `10.0.0.254` | LAN Games web application on TCP port `3000` |
| Student endpoints | Assigned addresses | Wired student access |

Do not connect a bag to a classroom wall jack, the university production
network, or another bag. The repeated address scheme is intentional because
each bag is physically isolated.

The current inventory associates the servers as follows:

| Server | Bag and switch | Switch port |
| --- | --- | --- |
| `SRV01` | `BG01-SW01` | `24` |
| `SRV02` | `BG01-SW02` | `24` |
| `SRV03` | `BG02-SW03` | `24` |
| `SRV04` | `BG02-SW04` | `24` |

The authoritative hardware list is [devices.yaml](../reference/inventory/devices.yaml).

## 2. What the configuration does

The switch baselines are organized by vendor, model, and physical switch in
[configs/lab01/](../../configs/lab01/). The Juniper EX3300 baselines are
[SW03](../../configs/lab01/juniper/ex3300/sw03/lab01.conf) and
[SW04](../../configs/lab01/juniper/ex3300/sw04/lab01.conf). The Cisco
directories currently contain setup-specific placeholders until sanitized
baselines are exported and reviewed.

### Identity and administration

- Sets a switch hostname such as `BG02-SW03`.
- Sets the local domain to `dep-bags.local`.
- Creates the `ta` administrative account and applies an idle timeout.
- Enables SSH protocol version 2 and limits concurrent SSH sessions.
- Disables root login over SSH.
- Restricts SSH to the authorized TA source address `10.0.0.250/32` with the
  `RE-PROTECT` loopback filter.
- Enables system, authorization, and interactive-command logging.

Credentials are intentionally omitted from the repository. Configure them
interactively through the approved secure deployment process; do not commit
plaintext passwords, password hashes, or private keys.

### Student, TA, server, and unused ports

- `ge-0/0/0` through `ge-0/0/2` are student access ports.
- `ge-0/0/22` is physical port 23, the TA management port.
- `ge-0/0/23` is physical port 24, the LAN Games server port.
- `ge-0/0/3` through `ge-0/0/21` are physical ports 4–22, disabled and
  placed in the `BRICK` VLAN.
- `BRICK` uses VLAN ID `999` so unused ports are isolated from the working LAN.
- Student, TA, and server ports use the default student LAN (`vlan.0`).

The Cisco setup guides use model-specific interface names and port conventions.
Use the matching guide for the hardware rather than translating commands
blindly:

- [Cisco 2960 setup](../labs/lab01/setup/cisco-2960.md)
- [Cisco 3750 setup](../labs/lab01/setup/cisco-3750.md)
- [Juniper EX3300 setup](../labs/lab01/setup/juniper.md)

### Layer 2 protections

- Student ports have a one-MAC limit and statically allowed MAC addresses.
- The TA port permits four documented TA device MAC addresses.
- Storm control is enabled on all interfaces.
- RSTP edge behavior is enabled on endpoint ports and BPDU blocking is enabled.
- LLDP and LLDP-MED are enabled for device discovery.

Replace the student and TA MAC placeholders with the actual authorized
hardware before committing the configuration. Each TA management port has four
authorized MAC-address placeholders. A stale MAC allow-list is a common reason
for a working device to show link but fail to pass traffic.

## 3. Prepare the Raspberry Pi server

The repository records the Pi hardware assignment and the expected service
address, but it does not currently include a Raspberry Pi image, application
package, container compose file, or service unit. The following procedure is
therefore the supported baseline for preparing a Pi; record the actual
application installation method used by the course team in the local handoff
notes.

### Initial operating-system setup

1. Install a supported 64-bit Ubuntu Server image on the Pi.
2. Set a unique hostname, for example `SRV03`.
3. Create a non-root administrative user and protect it with a course-managed
   secret.
4. Apply operating-system updates:

   ```sh
   sudo apt update
   sudo apt full-upgrade
   ```

5. Enable SSH.
6. Disable Wi-Fi and Bluetooth unless the exercise explicitly requires them.
   The Pi should have one wired network path only.

### Assign the server address

Configure the wired interface with:

| Setting | Value |
| --- | --- |
| Address | `10.0.0.254/24` |
| Default gateway | None |
| DNS | None required for the isolated lab |

The exact network manager depends on the image. After applying the setting,
verify the result with:

```sh
ip address show
ip route
ping -c 3 10.0.0.1
```

There should be no default route through the university network. If the Pi
requires temporary Internet access for updates, disconnect it from the bag,
perform the update on an approved maintenance network, and restore the
isolated configuration before class.

### Install and enable LAN Games

Install the course-approved LAN Games release using its maintained deployment
instructions. Configure it to listen on `0.0.0.0:3000` (or the Pi's wired
address on port `3000`) and configure it to start automatically after reboot.

Before class, verify the service locally on the Pi:

```sh
ss -ltnp | grep ':3000'
curl --fail http://127.0.0.1:3000/
```

If the application is managed by systemd, also verify:

```sh
systemctl is-enabled lan-games
systemctl is-active lan-games
```

If the course deployment uses a different service name or a container, replace
`lan-games` with the approved service name and use that deployment's health
check. Do not mark a bag ready until the application survives a reboot.

## 4. First-time switch setup

Use a console connection for first-time setup or recovery.

1. Identify the switch model and inventory ID.
2. Connect the TA computer to the console port.
3. Load the model-specific setup guide linked above.
4. Set the hostname to the bag and switch identity.
5. Set the management address to `10.0.0.1/24`.
6. Configure the student, TA, and Raspberry Pi ports for that model.
7. Replace all password and MAC-address placeholders.
8. Commit or save the configuration using the model-specific procedure.
9. Disconnect the console and test management through the approved TA port.

For the Juniper template, review the candidate configuration before committing:

```text
show | compare
commit check
commit confirmed 5
```

Confirm the connection remains usable, then finalize the commit:

```text
commit
```

Do not use `load override` or commit an unreviewed template on a production
device. The configuration is for the isolated deployment bag only.

## 5. Pre-class readiness check

Complete this checklist for each bag:

- [ ] Bag and switch inventory IDs match the documentation.
- [ ] No uplink connects the bag to a production or classroom network.
- [ ] Switch baseline is loaded and saved.
- [ ] Student ports are enabled only where needed.
- [ ] Unused ports are disabled and isolated in VLAN 999.
- [ ] The TA port accepts the authorized management device.
- [ ] The switch answers at `10.0.0.1`.
- [ ] The Raspberry Pi is connected to its documented server port.
- [ ] The Pi has `10.0.0.254/24` and no default route.
- [ ] LAN Games is listening on TCP `3000`.
- [ ] `http://10.0.0.254:3000` loads from a wired student laptop.
- [ ] A reboot test has been completed for the Pi and service.
- [ ] Console cable and power cables are present.

From a student laptop, verify:

```text
ping 10.0.0.1
ping 10.0.0.254
arp -a
```

The browser test is the final service check:

```text
http://10.0.0.254:3000
```

Peer-to-peer ICMP may fail because of endpoint firewall rules; that failure
does not by itself indicate a bad switch configuration if ARP resolution and
the game server work.

## 6. Troubleshooting

### No link light

Check power, cable seating, the assigned port, and whether the switch port is
administratively disabled. Confirm that the student or server cable is not
connected to an unused VLAN 999 port.

### Link exists, but the laptop cannot reach the Pi

Check the laptop address and mask, then confirm:

1. The laptop is in `10.0.0.0/24`.
2. The Pi is `10.0.0.254/24`.
3. The switch port is an access port in the student LAN.
4. The Pi service is listening on port `3000`.
5. Port security has the correct laptop MAC address.

### SSH to the switch fails

Use the physical TA port and the authorized source address
`10.0.0.250`. Confirm the TA device MAC allow-list and the loopback filter.
Use the console if the management address or security policy is uncertain.

### The Pi works locally but not from a laptop

Check `ip address`, `ip route`, `ss -ltnp`, and the Pi firewall. Confirm the
application is bound to the wired interface rather than only `127.0.0.1`.
Then inspect the switch MAC table and the port-security violation counter.

## 7. End-of-class restore

1. Save any instructor-approved student results outside the bag.
2. Disconnect student endpoints.
3. Restore the switch baseline using the model-specific setup guide.
4. Remove temporary MAC allow-list entries and test credentials.
5. Reboot the Pi and confirm that it returns to `10.0.0.254` and serves the
   LAN Games page.
6. Check that no default route or Wi-Fi connection is present.
7. Power down or secure the bag according to the room's equipment policy.
8. Record faults, missing cables, and changed hardware in the action-item
   folder under [docs/project/action-items/](../project/action-items/).

For the older Cisco router reset workflow, see
[00-reset-procedure.md](deployment/00-reset-procedure.md). Resetting a router
does not reset the switch or the Raspberry Pi.
