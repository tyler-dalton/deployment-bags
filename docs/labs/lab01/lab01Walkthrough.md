# W.I.P, moving screenshots in shortly.

# Lab 01: IPv4 Configuration and Connectivity Testing

## 1. Lab Overview

### Objective

Configure a computer with a static IPv4 address, verify connectivity to the network switch, test communication with another computer, and inspect the ARP table.

This guide provides instructions for:

- Windows
- macOS
- Linux (Fedora and other distributions)

## 2. Network Addressing

Use the following addressing scheme for this lab.

| Device | IPv4 Address | Subnet Mask |
|---|---|---|
| Network switch | `10.0.0.1` | `255.255.255.0` |
| Computer A | `10.0.0.10` | `255.255.255.0` |
| Computer B | `10.0.0.11` | `255.255.255.0` |

Both computers must use the same subnet mask and have unique IPv4 addresses.

The `/24` prefix is equivalent to the subnet mask `255.255.255.0`.

**Important:** These computer addresses are examples. Confirm that the address you plan to use is available and approved for your lab group before assigning it.

No default gateway or DNS server is required for communication between devices on this isolated subnet.

---

## 3. Windows Configuration

### Step 1: Open Network Connections

1. Press `Windows + R`.
2. Enter `ncpa.cpl`.
3. Press Enter.
4. Locate the physical **Ethernet** adapter connected to the lab network.
5. Right-click the adapter and select **Properties**.

Do not select Wi-Fi or a virtual adapter such as VirtualBox.

### Step 2: Configure IPv4

1. Select **Internet Protocol Version 4 (TCP/IPv4)**.
2. Click **Properties**.
3. Select **Use the following IP address**.
4. Enter the settings below.

| Setting | Value |
|---|---|
| IP address | `10.0.0.10` |
| Subnet mask | `255.255.255.0` |
| Default gateway | Leave blank |
| Preferred DNS server | Leave blank |
| Alternate DNS server | Leave blank |

5. Click **OK**.
6. Click **Close**.

If Windows requests administrator permission, use an authorized administrator account or ask the lab instructor for assistance.

### Step 3: Verify the IP address

Open Command Prompt or PowerShell.

Run:

```powershell
ipconfig
```

Locate the physical Ethernet adapter and confirm that it displays:

```text
IPv4 Address:    10.0.0.10
Subnet Mask:     255.255.255.0
```

Your output may contain additional information. Verify the physical Ethernet adapter rather than Wi-Fi or virtual adapters.

### Step 4: Ping the switch

Run:

```powershell
ping 10.0.0.1
```

**Expected result:** Replies from `10.0.0.1`.

If the first request times out but subsequent requests succeed, run the test again to check whether connectivity is consistent.

### Step 5: Ping the other computer

If Computer B is configured as `10.0.0.11`, run:

```powershell
ping 10.0.0.11
```

**Expected result:** Replies from `10.0.0.11`, provided the destination is reachable and its firewall permits ICMP echo requests.

### Step 6: Inspect the ARP table

Run:

```powershell
arp -a
```

Locate the interface associated with `10.0.0.10`.

Look for entries corresponding to:

- `10.0.0.1` — the switch
- `10.0.0.11` — Computer B

The table may display a physical address (MAC address) and an entry type such as `dynamic`.

If an entry is missing, ping the corresponding address and run `arp -a` again.

---

## 4. macOS Configuration

### Step 1: Open Network Settings

1. Open the Apple menu.
2. Select **System Settings**.
3. Open **Network**.
4. Select the wired Ethernet service connected to the lab network.

The service name may vary depending on the Mac and its Ethernet adapter.

### Step 2: Configure IPv4

1. Open the selected Ethernet service's details.
2. Locate **TCP/IP**.
3. Change **Configure IPv4** to **Manually**.
4. Enter the following settings.

| Setting | Value |
|---|---|
| IPv4 address | `10.0.0.10` |
| Subnet mask | `255.255.255.0` |
| Router | Leave blank |

5. Leave DNS configuration unchanged unless your instructor specifies otherwise.
6. Apply or save the settings.

Use `10.0.0.11` instead if this Mac is being used as Computer B.

### Step 3: Verify the IP address

Open **Terminal** using Spotlight Search.

Run:

```bash
ifconfig
```

Find the physical Ethernet interface. Its name may vary, for example, `en0` or `en5`.

Look for an IPv4 address such as:

```text
inet 10.0.0.10
```

Alternatively, if the interface name is known, run:

```bash
ipconfig getifaddr en0
```

Replace `en0` with the correct interface name.

### Step 4: Ping the switch

Run:

```bash
ping -c 4 10.0.0.1
```

The `-c 4` option sends four ping requests and stops.

**Expected result:** Replies from `10.0.0.1`.

### Step 5: Ping the other computer

If Computer B uses `10.0.0.11`, run:

```bash
ping -c 4 10.0.0.11
```

If the other computer is using `10.0.0.10`, reverse the destination accordingly.

**Expected result:** Replies from the destination address if the device is reachable and its firewall permits ICMP.

### Step 6: Inspect the ARP table

Run:

```bash
arp -a
```

Look for the other computer's IP address and its associated MAC address.

You can also inspect the switch entry if it has communicated with your computer.

---

## 5. Linux Configuration

These instructions use Fedora with NetworkManager. Other distributions may use different network configuration tools.

### Step 1: Identify the Ethernet interface

Open a terminal and run:

```bash
nmcli device status
```

Example output:

```text
DEVICE    TYPE      STATE      CONNECTION
enp0s25   ethernet  connected  Wired connection 1
wlp3s0    wifi      connected  Campus-WiFi
```

Identify the row where the type is `ethernet`.

In this example:

- Interface: `enp0s25`
- Connection profile: `Wired connection 1`

**Your interface and profile names may be different. Use the names shown on your computer.**

### Step 2: Identify the connection profile

Run:

```bash
nmcli connection show
```

Find the Ethernet connection's exact profile name in the `NAME` column.

### Step 3: Configure the static IP address

The following example assigns `10.0.0.11/24` to a Fedora Ethernet connection named `Wired connection 1`.

Run:

```bash
sudo nmcli connection modify "Wired connection 1" ipv4.method manual ipv4.addresses 10.0.0.11/24 ipv4.gateway "" ipv4.dns ""
```

Replace `Wired connection 1` with your actual profile name if necessary.

If you are configuring Computer A instead, use `10.0.0.10/24` instead of `10.0.0.11/24`.

The `sudo` command may request your Linux account password. Characters usually do not appear while you type the password.

### Step 4: Activate the configuration

Run:

```bash
sudo nmcli connection up "Wired connection 1"
```

Use the same profile name that you used in the previous command.

This may briefly interrupt the Ethernet connection.

### Step 5: Verify the IP address

Run:

```bash
ip -br addr
```

Find the Ethernet interface and confirm that it displays the intended address, such as:

```text
enp0s25    UP    10.0.0.11/24
```

### Step 6: Ping the switch

Run:

```bash
ping -c 4 10.0.0.1
```

**Expected result:** Replies from `10.0.0.1`.

### Step 7: Ping the other computer

If the other computer uses `10.0.0.10`, run:

```bash
ping -c 4 10.0.0.10
```

**Expected result:** Replies from `10.0.0.10` if the device is reachable and its firewall permits ICMP.

### Step 8: Inspect the neighbor table

Run:

```bash
ip neigh
```

Look for the other computer's IP address and its associated MAC address.

Example:

```text
10.0.0.10 dev enp0s25 lladdr d8:d0:90:49:f1:bb REACHABLE
```

The output will vary.

- `10.0.0.10` is the neighbor's IPv4 address.
- `dev enp0s25` identifies the local interface.
- `lladdr` displays the neighbor's MAC address.
- `REACHABLE` means the neighbor was recently confirmed reachable.

A `STALE` state is not automatically a problem. It means the mapping is cached but has not recently been confirmed.

---

## 6. Understanding Ping Results

Ping uses ICMP Echo Request and Echo Reply messages to test IP connectivity.

### Successful ping

Example:

```text
4 packets transmitted, 4 received, 0% packet loss
```

This indicates that all four requests received replies.

### Partial packet loss

Example:

```text
4 packets transmitted, 3 received, 25% packet loss
```

Some requests did not receive replies. Repeat the test and investigate if packet loss continues.

### Failed ping

Example:

```text
4 packets transmitted, 0 received, 100% packet loss
```

This does not automatically mean the devices are disconnected. Possible causes include incorrect addressing, a physical or VLAN issue, or firewall rules blocking ICMP.

---

## 7. Understanding ARP

ARP, or Address Resolution Protocol, helps IPv4 devices on a local network discover the MAC address associated with an IPv4 address.

When one computer communicates with another computer on the same subnet, it typically needs the destination's MAC address to send Ethernet frames.

The operating system can cache the resulting IP-to-MAC mapping.

### Commands by operating system

| Operating system | Command |
|---|---|
| Windows | `arp -a` |
| macOS | `arp -a` |
| Linux | `ip neigh` |

If an entry is missing, generate traffic by pinging the destination and inspect the table again.

A successful ARP lookup demonstrates local address resolution. It does not, by itself, prove that the destination application or ICMP service is responding.

---

## 8. Troubleshooting

### Incorrect IP address

Verify the configured address and subnet mask.

| Operating system | Verification command |
|---|---|
| Windows | `ipconfig` |
| macOS | `ifconfig` |
| Linux | `ip -br addr` |

Computer A and Computer B must have unique addresses on the intended subnet.

### Incorrect Linux connection profile

If NetworkManager reports that a connection is unknown, run:

```bash
nmcli connection show
```

Use the exact profile name shown in the output.

### Ping fails

1. Verify the IPv4 address and subnet mask.
2. Check whether the destination address is correct.
3. Verify the connection and VLAN configuration with the lab instructor if necessary.
4. Inspect the ARP or neighbor table.
5. Check whether the destination firewall permits ICMP Echo Requests.

Do not disable the firewall entirely to force a successful ping.

### Administrator permission errors

Windows may require an authorized administrator to modify network settings. Linux may require `sudo`.

If you lack the necessary permissions, ask your instructor or system administrator for assistance.

---
