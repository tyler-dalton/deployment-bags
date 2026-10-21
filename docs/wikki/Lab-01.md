<!-- markdownlint-disable-next-line MD026 -->
# Lab 01 — Build It. Connect It. Play.
<!-- markdownlint-disable-next-line MD036 -->
**IT1080C Computer Networking | Physical Networking Lab**

## The Challenge

Your mission is simple: **build a working network and use it to access a local game server.**

The games are already hosted on a Raspberry Pi inside your isolated lab environment. However, your laptop must be properly connected and configured before you can access them.

Your destination:
<!-- markdownlint-disable-next-line MD034 -->
**http://10.0.0.254:3000**

You won't need an Internet connection to access this server. Everything happens inside your local network.

> **[SCREENSHOT NEEDED — 01]** LAN Games home screen. This should be the first major visual students see, before the technical instructions.

## What You'll Accomplish

By the end of this lab, you should be able to:

- Identify and connect physical networking equipment.
- Configure a static IPv4 address and subnet mask.
- Establish communication with another device on the same LAN.
- Access a locally hosted web application.

## Part 1 — Deploy Your Network

### Step 1: Identify Your Equipment

Locate the equipment assigned to your lab group.

You should have access to a network switch, student laptop, Ethernet cabling, and the deployment bag's supporting infrastructure.

> **[SCREENSHOT NEEDED — 02]** Labeled photo of the complete deployment bag with relevant equipment identified.

### Step 2: Establish Physical Connections

1. Position the deployment bag in the designated workspace.
2. Connect the deployment equipment to its designated power source as directed by your TA.
3. Connect your student laptop's Ethernet port to its assigned student-facing switch port (see table below).
4. Verify that the necessary networking equipment and local server are powered on.
5. Check for link/activity indicators on the connected Ethernet interfaces.

#### Group 1 | Switch 1 (SW01)

| Laptop Asset ID | Switch | Port | IP Address | Subnet |
| --- | --- | --- | --- | --- |
| LP01 | SW01 | 1 | 10.0.0.3 | 255.255.255.0 |
| LP02 | SW01 | 2 | 10.0.0.4 | 255.255.255.0 |
| LP03 | SW01 | 3 | 10.0.0.5 | 255.255.255.0 |

#### Group 2 | Switch 2 (SW02)

| Laptop Asset ID | Switch | Port | IP Address | Subnet |
| --- | --- | --- | --- | --- |
| LP04 | SW02 | 1 | 10.0.0.3 | 255.255.255.0 |
| LP05 | SW02 | 2 | 10.0.0.4 | 255.255.255.0 |
| LP06 | SW02 | 3 | 10.0.0.5 | 255.255.255.0 |

#### Group 3 | Switch 3 (SW03)

| Laptop Asset ID | Switch | Port | IP Address | Subnet |
| --- | --- | --- | --- | --- |
| LP07 | SW03 | 1 | 10.0.0.3 | 255.255.255.0 |
| LP08 | SW03 | 2 | 10.0.0.4 | 255.255.255.0 |
| LP09 | SW03 | 3 | 10.0.0.5 | 255.255.255.0 |

#### Group 4 | Switch 4 (SW04)

| Laptop Asset ID | Switch | Port | IP Address | Subnet |
| --- | --- | --- | --- | --- |
| LP10 | SW04 | 1 | 10.0.0.3 | 255.255.255.0 |
| LP08 | SW04 | 2 | 10.0.0.4 | 255.255.255.0 |
| LP09 | SW04 | 3 | 10.0.0.5 | 255.255.255.0 |

> [!IMPORTANT]
> Use only your group's assigned Ethernet ports. Do not connect the deployment bag to UC's production network or classroom wall Ethernet outlets.

### Checkpoint 1 — Physical Connectivity

Before proceeding, verify:

- [ ] Equipment is powered on.
- [ ] Laptop is connected to the assigned switch port.
- [ ] Ethernet cable is securely connected.
- [ ] Expected link indicators are active.

An Ethernet link does not automatically mean your network is fully operational. Next, you need to configure how your laptop communicates.

> **Having trouble?**
> Jump to [Troubleshooting](#troubleshooting).

---

## Part 2 — Configure Your IPv4 Address

Every device on a network needs appropriate addressing information to communicate.

Your lab uses the network `10.0.0.0/24`.

| Device | IPv4 Address |
| --- | --- |
| Network switch | `10.0.0.1` |
| Local game server | `10.0.0.254` |
| Student laptop | Assigned by your TA |

### Step 3: Open Network Connections

On your Windows laptop:

1. Press `Windows + R`.
2. Enter `ncpa.cpl`.
3. Press Enter.
4. Find the physical **Ethernet** adapter connected to your deployment bag.
5. Right-click the adapter and select **Properties**.

> **[SCREENSHOT NEEDED — 03]** Windows Run dialog with `ncpa.cpl` entered.
<!-- markdownlint-disable-next-line -->
> **[SCREENSHOT NEEDED — 04]** Network Connections window showing the correct Ethernet adapter.
<!-- markdownlint-disable-next-line -->
> **Having trouble?**
> Jump to [Troubleshooting](#troubleshooting).

### Step 4: Configure Static IPv4

1. Select **Internet Protocol Version 4 (TCP/IPv4)**.
2. Click **Properties**.
3. Select **Use the following IP address**.
4. Enter your assigned network settings.

| Setting | Value |
| --- | --- |
| IP address | Your assigned address, for example: `10.0.0.10` |
| Subnet mask | `255.255.255.0` |
| Default gateway | Leave blank |
| Preferred DNS server | Leave blank |

The IP address must be unique within your lab network. **Do not use `10.0.0.1` or `10.0.0.254` for your laptop**, as those addresses are reserved for the switch and server.
<!-- markdownlint-disable MD029 -->
5. Click **OK** to save the configuration.
6. Close the remaining network settings windows.

> **[SCREENSHOT NEEDED — 05]** IPv4 Properties dialog with example settings completed.
<!-- markdownlint-disable-next-line -->
> **Having trouble?**
> Jump to [Troubleshooting](#troubleshooting).

### Step 5: Verify Your Configuration

Open Command Prompt:

1. Press `Windows + R`.
2. Enter `cmd`.
3. Press Enter.

Run:

```powershell
ipconfig
```

Find the Ethernet adapter and confirm that its IPv4 address and subnet mask match the assigned values.

> **[SCREENSHOT NEEDED — 06]** Command Prompt showing a successful `ipconfig` result. Highlight the IPv4 address and subnet mask.

### Checkpoint 2 — IPv4 Configuration

- [ ] Laptop has the assigned IPv4 address.
- [ ] Subnet mask is `255.255.255.0`.
- [ ] No duplicate IP address is being used.

---

## Part 3 — Connect to LAN Games

### Step 6: Open the Game Server

You've assembled your network and configured your laptop. Now it's time to see whether everything works.

1. Open your laptop's web browser.
2. Click the address bar.
3. Enter:
<!-- markdownlint-disable MD034 -->
**http://10.0.0.254:3000**

4. Press Enter.

Use the complete address, including `http://` and `:3000`.

If your network is working correctly and the game server is available, the LAN Games interface should load.

> **[SCREENSHOT NEEDED — 07]** Successfully loaded LAN Games landing page. Highlight Browser address bar showing `http://10.0.0.254:3000`.
<!-- markdownlint-disable-next-line -->
> **Having trouble?**
> Jump to [Troubleshooting](#troubleshooting).

### Step 7: Explore LAN Games

Once connected, feel free to briefly explore the different games provided by lan-games, before returning for completion of the lab.

### Checkpoint 3 — Connection Successful

- [ ] LAN Games loads in the browser.

**You've successfully deployed and connected to a physical local area network!**

---

## Part 4 — Verify Your Network

A working browser connection is useful evidence, but networking tools can tell us more about the communication taking place.

### Step 8: Test Server Connectivity

Return to Command Prompt and run:

```powershell
ping 10.0.0.254
```

Ping sends ICMP Echo Requests to test whether the destination responds.

If the server is configured to respond to ICMP, successful output should contain replies from `10.0.0.254`.

> **[SCREENSHOT NEEDED — 08]** Successful ping output from the local server, if ICMP replies are enabled.

### Step 9: Inspect the ARP Table

Run:

```powershell
arp -a
```

ARP helps IPv4 devices discover the MAC addresses associated with other devices on the local network.

Look for an entry associated with `10.0.0.254`.

The corresponding physical address is the server's MAC address as observed by your laptop.

> **[SCREENSHOT NEEDED — 09]** ARP table showing the local server's IP-to-MAC mapping.

### Why This Matters

Your laptop uses several networking technologies to reach LAN Games:

- **Ethernet:** Provides the wired connection to the network.
- **IPv4:** Identifies your laptop and the local server.
- **ARP:** Resolves local IPv4 addresses to MAC addresses.
- **TCP:** Supports reliable communication with the web server.
- **HTTP:** Allows the browser to request the application.

The networking concepts discussed in class are now supporting an application you can actually use.

At this point in time, you are free to connect with your peers on the same network, create lobbies, and begin playing lan-games!

---

## Troubleshooting

If LAN Games doesn't load, don't immediately assume the server is broken. Troubleshooting means identifying where communication fails.

### No Ethernet Connection

Check that the cable is firmly seated, the assigned switch port is correct, and the equipment is powered on.

### Incorrect IPv4 Configuration

Run `ipconfig` and verify your assigned address and subnet mask.

Your laptop and server must be able to communicate within the intended network.

### Browser Cannot Reach the Server

Check that you entered the complete address:

`http://10.0.0.254:3000`

Ensure the browser has not changed the URL to HTTPS.

From the terminal run: `ping 10.0.0.254` to verify basic connectivity.

### Server Does Not Respond

Ask your TA to verify that the Raspberry Pi and LAN Games service are operating. Students should not modify the server or switch configurations.

### Still Having Problems?

Work through the following sequence:

1. Confirm physical Ethernet connectivity.
2. Confirm the assigned IPv4 configuration.
3. Verify the server address and browser URL.
4. Test network communication where applicable.
5. Ask your TA for assistance with infrastructure-related problems.

---

## Lab Completion

Before concluding the activity, verify that you have:

- [ ] Deployed the assigned networking equipment.
- [ ] Configured the correct static IPv4 address.
- [ ] Accessed LAN Games through the local server.
- [ ] Inspected the network configuration and ARP table.
- [ ] Followed your TA's directions for returning the equipment to its initial condition.

---

<!-- markdownlint-disable-next-line MD036 -->
*IT1080C Computer Networking · University of Cincinnati*
