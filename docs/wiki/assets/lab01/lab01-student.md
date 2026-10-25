# Lab 01: Build It. Connect It. Play.

**IT1080C Computer Networking | Physical Networking Lab**

![LAN Games banner](../../labs/lab01/media/student-docs/lan-games-banner.png)

Your first challenge is to deploy a local area network, configure your computer's IPv4 settings, and establish a connection to a locally hosted game server.

> **Heads up: there is a quiz at the end of this lab.** Pay close attention to what you see and do at each step, because the quiz is based on what you observe along the way.

---

## Important Rules

Use only the equipment assigned to your group. Other groups' equipment is configured differently, and swapping cables or devices can break their network.

**Do not** connect your lab network to UC_Secure or campus Ethernet wall outlets. Your lab network uses addresses that could conflict with the campus network and cause problems for other users.

**Do not** modify switch configurations unless specifically instructed. The switch is already set up for you.

Keep cables organized and avoid unnecessary equipment disconnections. Unplugging a device in the middle of a step can make results confusing.

Notify your TA or instructor if equipment is damaged or behaving unexpectedly. Don't try to fix hardware yourself.

### What You'll Learn

Through deployment activities, you'll gain practical experience with:

- **Ethernet connections and physical networking:** how devices are physically cabled together

- **IPv4 addressing and subnet masks:** how devices are given "addresses" and how they know who is nearby

- **Communication between devices on a local network:** how two devices find each other and exchange data

- **Basic networking commands (`ping`, `arp`):** simple tools used by network professionals every day

### What You'll Accomplish

By the end of this lab, you should be able to:

- Identify and connect physical networking equipment.

- Configure a static IPv4 address and subnet mask.

- Establish communication with another device on the same LAN.

- Access a locally hosted web application.

### Key Terms

Skim these now and come back to them whenever you need a refresher.

| Term | Plain-English Meaning |
| --- | --- |
| **LAN (Local Area Network)** | A small network in one location (your lab bench, a classroom, a home). |
| **Switch** | A box with many Ethernet ports. It connects devices together so they can talk to each other on a LAN. |
| **Server** | A computer that provides a service to other devices. Here, your Raspberry Pi serves the games. |
| **Client** | A device that uses a service. Here, your laptop is the client. |
| **IPv4 address** | A number like `10.0.0.5` that identifies a device on a network, similar to a street address. |
| **Subnet mask** | A number like `255.255.255.0` that tells a device which other addresses are "on my local network." |
| **Static IP** | An address you type in yourself, rather than one assigned automatically. |
| **MAC address** | A unique hardware ID built into every network adapter, like `b8-27-eb-12-34-56`. |
| **Port** | A numbered "door" on a device. One device can offer many services, each on a different port. |

---

## The Challenge

Your mission is simple: **build a working network and use it to access a local game server.**

The games are hosted on a Raspberry Pi inside your deployment bag. To access them, you'll need to connect and configure your laptop. **No Internet connection is required.** Everything happens on your own small network.

Here's the big picture of what you're building:

```text

+-------------+          +-------------+          +-----------------+
|   Laptop    |          |   Switch    |          |  Raspberry Pi   |
|  (client)   |==========|             |==========|  (game server)  |
| 10.0.0.3-5  |  cable   |  10.0.0.1   |  cable   |   10.0.0.254    |
+-------------+          +-------------+          +-----------------+

Network: 10.0.0.0/24 (subnet mask 255.255.255.0)

```

> **[SCREENSHOT NEEDED — 01]** LAN Games home screen. This should be the first major visual students see, before the technical instructions.

---

## Part 1 - Get to Know Your Environment

### Step 1: Identify Your Equipment

Open your deployment bag and lay out everything on your workspace. Check that you have each item in the table below. If anything is missing, tell your TA or instructor **before** continuing.

| Item | What It Is | What It Does in This Lab |
| --- | --- | --- |
| **Laptop** | Your computer | The client: you'll use it to configure settings and play the games. |
| **Raspberry Pi** | A small, credit-card-sized computer | The server: it hosts the LAN Games. |
| **Network switch** | A box with several Ethernet ports | Connects your laptop and the Pi so they can communicate. |
| **Ethernet cables (x[2])** | Cables with a clip-style plug on each end | Physically link devices to the switch. |
| **Power adapters** | Power supplies for the Pi and the switch | Provide power. Neither device has an on/off button; they start when plugged in. |
| **[USB-to-Ethernet adapter, if needed]** | A small dongle | Gives your laptop an Ethernet port if it doesn't have one built in. |

> **Tip:** Ethernet ports look like a slightly wider phone jack. The plug only goes in one way and should *click* when seated. Don't force it.

### Step 2: Log In

Open your laptop and sign in with the account provided by your instructor: [username / password, or "your UC credentials"].

Once you reach the desktop, open a command-line window. You'll use it throughout this lab. Press the **Windows key**, type `cmd`, and press **Enter** to open *Command Prompt*.

Leave this window open. Each step tells you which command to type.

> **Note:** Everything you type goes in the command-line window, then press **Enter** to run it. Commands are not case-sensitive, but type them exactly as shown.

### Step 3: First ARP Check

Before you connect anything, let's take a "before" snapshot so you can see what changes later.

> **What is ARP?**

> Every device on a network has two identities: an **IP address** (which can change) and a **MAC address** (permanently built into the hardware). Before your laptop can send data to another device on the LAN, it has to learn that device's MAC address. It does this using the **Address Resolution Protocol (ARP)**.

>

> Your laptop keeps a small list of what it has learned, called the **ARP table** (or ARP cache). It's like a personal phone book matching IP addresses to MAC addresses.

>

> The command `arp -a` displays that table.

**Run this command:**

```text

arp -a

```

**What you're looking at:**

| Column | Meaning |
| --- | --- |
| **Interface** (or the line starting with an address) | Which of *your* network adapters this list belongs to. |
| **Internet Address** | The IP address of another device your laptop has talked to. |
| **Physical Address** | That device's MAC address (a mix of numbers and letters, like `b8-27-eb-12-34-56`). |
| **Type** | `dynamic` means the laptop learned it automatically. `static` means it was set permanently (you'll often see these for special addresses like `224.0.0.22`). |

**What to expect right now:** your equipment is not connected, so the table should be short or empty. You might see a message such as "No ARP Entries Found," or a few entries for special addresses. Either is fine. You are recording what the table looks like *before* the network exists.

> **[SCREENSHOT NEEDED]** ARP check without the cable being connected.

---

## Part 2 - Deploy Your Network

### Step 4: Connect Your Equipment

Now you'll physically build the network. Follow this order:

**Power the switch:** plug its power adapter into an outlet. Wait for its lights to come on.

**Power the Raspberry Pi:** plug in its power adapter. The Pi needs about **1-2 minutes** to start up. [Update this time to match your Pi image.]

**Cable the Pi to the switch:** connect one end of an Ethernet cable to the Pi's Ethernet port and the other end to the **Pi's port** on the switch. [Specify, e.g., Port 24.] Don't use Ports 1-3, which are reserved for laptops.

**Cable your laptop to the switch:** connect a second Ethernet cable from your laptop's Ethernet port (or adapter) to the **switch port assigned to your laptop** (Port 1, 2, or 3). You'll find your assigned port in the table in Step 6. [Update if the Pi uses a specific port, e.g., Port 24.]

**Check the link lights.** Small LEDs near each Ethernet port should glow or blink. That means the devices detected each other physically.

> **Warning:** Use only *your* group's switch. **Never** plug into a wall jack or into a switch belonging to another group.

**Checkpoint:** Before moving on, confirm that:

- [ ] The switch has power and its lights are on.

- [ ] The Pi has power and has had at least a minute to start.

- [ ] Both Ethernet cables are firmly clicked in at both ends.

- [ ] Link lights are on for both the laptop's and the Pi's switch ports.

### Step 5: Check ARP Again

Run the same command from earlier:

```text

arp -a

```

**What to look for:** compare this result with your "before" snapshot.

You've plugged in the cables, but your laptop hasn't sent anything to the other devices yet, and its network settings aren't configured. So the ARP table will likely still show no entries for the switch or Pi. You may see your laptop's Ethernet adapter listed with an address starting with `169.254`. That is a temporary, self-assigned address your laptop gave itself because it couldn't find any other. You'll fix that in Part 3.

> **Key idea:** A physical cable alone doesn't make devices "talk." They also need compatible IP settings. That's what you'll configure next.

> **[SCREENSHOT NEEDED]** ARP check after cables are connected but before the IPv4 address is configured.

---

## Part 3 - Configure Your Laptop

Your laptop needs an IPv4 address that belongs to the same network as the switch and Pi. Think of it like a neighborhood: to chat across the fence, you all have to live on the same street.

### Step 6: Assign IPv4 Address

You will enter these values by hand (a **static** configuration).

Your lab network is **10.0.0.0/24**. Two addresses are already taken:

| Device | IP Address |
| --- | --- |
| Switch | `10.0.0.1` |
| Raspberry Pi (server) | `10.0.0.254` |

> **Instructor Reminder:** Explain why the switches have IPs.

Your laptop needs its own address on the same network, so it must start with `10.0.0.` and end with a number that no other device on *your* switch is using.

#### Find Your Assigned Address

Find the **Laptop Asset ID** (for example, `LP05`) on the sticker on your laptop.

Find your **switch label** (for example, `SW02`) on the front of your switch.

Look up your laptop's row in the table for your group below. It tells you which **switch port** to plug into and the **IP address** to enter.

##### Group 1 | Switch 1 (SW01)

| Laptop Asset ID | Switch | Port | IP Address | Subnet |
| --- | --- | --- | --- | --- |
| LP01 | SW01 | 1 | 10.0.0.3 | 255.255.255.0 |
| LP02 | SW01 | 2 | 10.0.0.4 | 255.255.255.0 |
| LP03 | SW01 | 3 | 10.0.0.5 | 255.255.255.0 |

##### Group 2 | Switch 2 (SW02)

| Laptop Asset ID | Switch | Port | IP Address | Subnet |
| --- | --- | --- | --- | --- |
| LP04 | SW02 | 1 | 10.0.0.3 | 255.255.255.0 |
| LP05 | SW02 | 2 | 10.0.0.4 | 255.255.255.0 |
| LP06 | SW02 | 3 | 10.0.0.5 | 255.255.255.0 |

##### Group 3 | Switch 3 (SW03)

| Laptop Asset ID | Switch | Port | IP Address | Subnet |
| --- | --- | --- | --- | --- |
| LP07 | SW03 | 1 | 10.0.0.3 | 255.255.255.0 |
| LP08 | SW03 | 2 | 10.0.0.4 | 255.255.255.0 |
| LP09 | SW03 | 3 | 10.0.0.5 | 255.255.255.0 |

##### Group 4 | Switch 4 (SW04)

| Laptop Asset ID | Switch | Port | IP Address | Subnet |
| --- | --- | --- | --- | --- |
| LP10 | SW04 | 1 | 10.0.0.3 | 255.255.255.0 |
| LP11 | SW04 | 2 | 10.0.0.4 | 255.255.255.0 |
| LP12 | SW04 | 3 | 10.0.0.5 | 255.255.255.0 |

> **Why do different groups use the same addresses?** Each group has its own switch and its own Raspberry Pi, and the switches are **not connected to each other**. That makes four separate, isolated networks. An address only has to be unique *within its own network*, so Group 1 and Group 2 can both have a `10.0.0.3` without conflict. This is also why you must only use your own group's equipment.

Enter these values:

| Setting | Value to Enter | What It Means |
| --- | --- | --- |
| **IP address** | The address from your row in the table above (`10.0.0.3`, `.4`, or `.5`) | The unique address of your laptop on this network. |
| **Subnet mask** | `255.255.255.0` | Tells your laptop that devices sharing the first three numbers (`10.0.0.`) are "local." |
| **Default gateway** | *Leave blank* | A gateway is the exit to other networks, such as the Internet. Your lab network has none. |
| **DNS server** | *Leave blank* | DNS translates names to IP addresses. Not needed here. |

**Your laptop's IP address:** `10.0.0.****`

> **What does "/24" mean?** The number after the slash is shorthand for the subnet mask. `/24` is the same as `255.255.255.0`. It means the first three numbers (`10.0.0`) identify the *network*, and the last number identifies the individual *device* on it. That gives room for addresses `10.0.0.1` through `10.0.0.254` on your LAN.

> **Never use** `10.0.0.1` (the switch) or `10.0.0.254` (the server) for your laptop. Doing so would break the network for everyone on your switch.

> **Why can't two laptops on the same switch share an address?** Two devices on one network can't have the same IP address. It's like two houses with the same street address, and data wouldn't know where to go. If a teammate's laptop on your switch uses a different row, you're fine.

#### Set the Address in Windows

Press **Win + R** on your keyboard to open the *Run* box.

1. Type `ncpa.cpl` and press **Enter**. This opens the **Network Connections** window, which lists all of your laptop's network adapters.

2. Right-click the adapter named **Ethernet** (it may be called *Ethernet 2* if you're using a USB adapter) and choose **Properties**. Don't pick Wi-Fi or any adapter labeled *Bluetooth* or *Virtual*. If the Ethernet icon shows a red X, check your cable.

3. In the list, click **Internet Protocol Version 4 (TCP/IPv4)** so it's highlighted, then click **Properties**. Leave the checkbox ticked. Don't touch IPv6.

4. Select **Use the following IP address**.

5. Enter the **IP address** and **Subnet mask** from your row in the table. Windows may fill in the subnet mask automatically when you click in the box. Make sure it reads `255.255.255.0`.

6. Leave **Default gateway** and all **DNS server** boxes **empty**.

7. Click **OK**, then **OK** (or **Close**) again to save. If you skip this, the settings won't apply.

> **Admin prompt:** If Windows asks for administrator permission, use the credentials from your instructor: [credentials / "approve the prompt"].

> **To undo later:** Return to the same window and choose **Obtain an IP address automatically** and **Obtain DNS server address automatically**.

> **Tip:** If Windows warns that there is "no Internet," that's expected. Your lab network is intentionally isolated.

### Step 7: Verify IPv4 Configuration

Never assume a setting took effect. Always confirm it.

**Run:**

```text

ipconfig

```

Find the section for your **Ethernet** adapter (ignore Wi-Fi and any "Virtual" or "Bluetooth" adapters) and confirm:

- [ ] **IPv4 Address** matches the address in your row of the Step 6 table.

- [ ] **Subnet Mask** is `255.255.255.0`.

- [ ] **Default Gateway** is blank.

If the values are wrong or your IP still starts with `169.254`, go back to Step 6 and recheck your entries for typos.

> **[SCREENSHOT NEEDED]** `ipconfig` output showing the correct IPv4 address and subnet mask.

---

## Part 4 - Test Your Network

### Step 8: Ping the Switch

> **What is ping?**

> `ping` sends a small test message to another device and waits for a reply. If the device answers, you know the two can communicate. It's the network equivalent of calling out "Hello, can you hear me?" and listening for "Yes!"

**Run this command:**

```text

ping 10.0.0.1

```

Windows sends 4 test messages and then stops on its own.

**How to read the results:**

| What You See | What It Means |
| --- | --- |
| `Reply from 10.0.0.1: bytes=32 time<1ms TTL=64` | **Success!** The device answered. `time` is how long the round trip took. |
| `Request timed out.` | No answer. Check cables, your IP settings, and the switch's power. |
| `Destination host unreachable.` | Your laptop doesn't think the address is on its network. Recheck your IP and subnet mask. |

A successful test typically shows **4 replies** and **0% loss**.

> **[SCREENSHOT NEEDED]** Successful ping to the switch.

### Step 9: Check ARP One Last Time

```text

arp -a

```

**What changed?** Because you pinged the switch, your laptop had to ask "who has this IP address?" The switch answered with its MAC address, and your laptop saved that answer in its ARP table. You should now see a new entry with the **switch's IP address** (`10.0.0.1`) and its **MAC address**.

> **Key idea:** Communication on a LAN happens by MAC address under the hood. ARP is the bridge between the IP addresses we use and the MAC addresses the hardware needs.

> **[SCREENSHOT NEEDED]** ARP table showing the switch's IP and MAC address.

### Step 10: Ping the Server

Now test the real target, the Raspberry Pi (server) at `10.0.0.254`.

```text

ping 10.0.0.254

```

You should see the same kind of successful replies as in Step 8. If you get timeouts, wait another minute (the Pi may still be starting), then try again.

> **[SCREENSHOT NEEDED]** Successful ping to the Raspberry Pi server.

### Step 11: Check ARP One Last Time

```text

arp -a

```

You should now see a **second new entry**: the Raspberry Pi's IP address (`10.0.0.254`) with its MAC address. Notice that the Pi's MAC address likely starts with a manufacturer prefix (such as `b8-27-eb`, `dc-a6-32`, or `e4-5f-01`), which identifies it as a Raspberry Pi.

**Quick check:** your ARP table should now contain entries for both the **switch** and the **server**.

> **[SCREENSHOT NEEDED]** ARP table showing both the switch and the Raspberry Pi.

---

## Part 5 - Connect to lan-games

Your network is working. Now let's use it.

### Step 12: Open the Server

Open a web browser (Chrome, Edge, or Firefox) on your laptop.

In the address bar, type `http://` followed by the Raspberry Pi's IP address and press **Enter**:

```text

http://10.0.0.254

```

**Write down exactly what happens** (an error message, a blank page, or a different page), and take a screenshot if you can. Good network technicians always record what they observe.

> **Why does this work with no Internet?** A web page is just data sent from a server to a client. The Pi is running a web server program, and your browser is the client. They're connected by your LAN. Nothing leaves your bench.

### Step 13: Find the Right Port

A single device can run many services at once. **Ports** are how a device keeps them separate. Think of the IP address as the building address, and the port as the apartment number.

By default, browsers use port **80** for `http://` addresses. If the game server runs on a different port, you must add it to the address after a colon:

```text

http://10.0.0.254:port

```

**The LAN Games server runs on port `3000`.** Enter this in your browser's address bar:

```text

http://10.0.0.254:3000

```

**If the page doesn't load:**

- [ ] Check that you typed a colon (`:`) and not a semicolon (`;`) before the port.

- [ ] Make sure the address starts with `http://`, not `https://`.

- [ ] Confirm you can still ping the Pi.

- [ ] Make sure you typed `3000` exactly, with no spaces.

When it works, you'll see the LAN Games home screen. 🎉

> **[SCREENSHOT NEEDED]** Browser showing the LAN Games home screen with the IP address and port visible in the address bar.

---

## Part 6 - Submit & Play

### Step 14: Complete the Quiz

Open the quiz on [Canvas / link]. It's short, and it's based on **what you observed** during this lab, so use your notes and screenshots.

**Tips for strong answers:**

- Refer to specific things you saw (for example, what appeared in your ARP tables and when, or what the browser showed).

- Use the terms from this lab, such as *ARP table*, *MAC address*, *ping*, and *port*.

- Explain *why* something happened, not just *what* happened. Two or three clear sentences per question is plenty.

[Include any screenshots or files to upload here.]

**Before you start, make sure you have:**

- [ ] A screenshot of your `ipconfig` output

- [ ] Screenshots of your ping results

- [ ] Screenshots of your ARP tables

- [ ] Your notes on what you observed at each step, including Step 12

### Step 15: Game Time

You earned it! Once the quiz is submitted, choose a game and play. While you do, think about this: every move you make travels from your laptop, through the cable, into the switch, out to the Pi, and back again, all on the network *you* built.

When you're done, ask your TA before packing up.

**Clean-up checklist:**

- [ ] Close your browser and command-line windows.

- [ ] Unplug power adapters, then Ethernet cables.

- [ ] Coil cables loosely (no tight kinks) and return everything to your bag.

- [ ] Change your laptop's IPv4 setting back to **Automatic (DHCP)**, so it works normally on the campus network. *(Same `ncpa.cpl` window as Step 6, but choose "Obtain an IP address automatically" and "Obtain DNS server address automatically.")*

---

## Troubleshooting

Work through problems **in order** from the physical layer upward. Most issues are cables or typos.

| Problem | Likely Cause | What to Try |
| --- | --- | --- |
| No link lights at a switch port | Cable not fully seated, bad cable, or no power | Re-seat both ends until they click. Confirm the switch has power. Try a different port. |
| `ipconfig` shows an IP starting with `169.254` | The static address didn't save | Redo Step 6, making sure you chose **Manual** and clicked **Save**. |
| `ipconfig` shows no Ethernet adapter | Adapter not detected | Reseat the USB-to-Ethernet adapter (if used), or restart the laptop. |
| Ping says `Request timed out` | Pi still starting, wrong IP, or loose cable | Wait 1-2 minutes. Recheck the IP you typed. Check cables and link lights. |
| Ping says `Destination host unreachable` | Wrong IP or subnet mask on your laptop | Compare your settings against the table in Step 6. |
| `arp -a` doesn't show the switch or Pi | You haven't pinged them yet | Run `ping` first. ARP only records devices you've communicated with. |
| The browser says "This site can't be reached" | Wrong port, `https://` used, or typo | Check the address, include the port, and use `http://`. |
| Internet pages won't load | Expected behavior | Your lab network has no Internet connection. This is by design. |
| Pings work sometimes, or a warning about a duplicate IP appears | Another device is using the same address | Confirm your address matches your row in the Step 6 table, and that you're plugged into your assigned port. Ask your TA. |

> **Still stuck?** Raise your hand and tell your TA: (1) which step you're on, (2) what you expected to happen, and (3) what actually happened. Having that ready will get you help faster.
