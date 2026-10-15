
# Cisco Router, Switch, & Laptop Lab

## Equipment List

The following equipment is needed for this lab:

- Cisco 1900 Series Router
- Network Switch
- Laptop or computer
- Cat5e Ethernet cable
- Console cable
- Tera Term or PuTTY [May need to download one of these programs if you dont already have them]
- Power cables

---

## Step 1: Gather and Connect the Equipment

Before beginning the configuration, gather all required equipment.

1. Place the router, switch, and laptop in an accessible workspace.
2. Connect the power cables to the router and switch.
3. Power on the router and switch.
4. Verify that the power lights are illuminated.
5. Check the link and activity lights on the connected network ports.

---

## Step 2: Connect the Router to the Switch

1. Locate the router's **Gigabit Ethernet 0/0 (GE0/0)** port.
2. Connect one end of a Cat5e Ethernet cable to the router's GE0/0 port. Preferably the port numbered 1.
3. Connect the other end of the cable to an available port on the switch. Preferably the port numbered 2.
4. Check the link and activity lights on both devices.
5. Confirm that the physical connection is established.

---

## Step 3: Access the Router Console

A console connection is used to access the router's command-line interface (CLI).

1. Connect the console cable from your computer to the router.
2. Open PuTTY. **NOTE: You can download PuTTY off the Microsoft store if needed**
3. Configure the connection settings:

- 
**Connection Type:** Serial
- **Serial Line:** COM6 (or the COM port assigned to the console cable)
- **Speed:** 9600 baud
- To do this, you will have to select the "Session" tab, and once you have selected that tab, you will be given a few different options.

<img width="655" height="429" alt="CYBERpicturesforSERVERV2" src="https://github.com/user-attachments/assets/6831d8a0-00aa-4a66-ba3a-2cba6ffb27f5" />

4. Attempt to establish a console connection.

Select **Open** in PuTTY to launch the serial console session.
A terminal window should appear, allowing communication with the Cisco 1941 router.



## Access User EXEC Mode

Once the console connection is established, the router prompt should appear:
Router>

5. If PuTTY does not work correctly, open Tera Term instead.
6. Select the appropriate serial connection. Most likely will show up as COMM 5 or 6.
   <img width="655" height="429" alt="CYBERpicturesforSERVERV2" src="https://github.com/user-attachments/assets/0738aa9f-8bcc-4e42-8e8c-73b717bf27fc" />

8. Open the router's console. You may have to click enter a few times once the terminal window is open. It is a black screen
   where you can type things. Your terminal should say Router>
   
   [Below is an example of a router CLI that already has Privileged EXEC Mode enabled. You will enable this in step 4. Both PuTTY & Tera Term's CLI should look very similar.]

   <img width="652" height="427" alt="CLIcyberPICTURE" src="https://github.com/user-attachments/assets/2a78e191-f80c-4363-ba53-8df115a003d4" />

---

## Step 4: Enter Privileged EXEC Mode

After accessing the router console, enter privileged EXEC mode.

**Command:**

`enable`

This command provides access to additional router configuration commands.

It should now say Router#

---

## Step 5: Enter Global Configuration Mode

Enter global configuration mode to make changes to the router.

**Command:**

`configure terminal`

This mode allows the administrator to configure router settings.

It should now say Router(config)#

---

## Step 6: Select the Router Interface

Select the router's Gigabit Ethernet 0/0 interface.

**Command:**

`interface gigabitEthernet 0/0`

This command opens the configuration settings for the selected interface.

It should now say Router(config-if)#

---

## Step 7: Configure the Interface IP Address

Assign the IP address to the router's GE0/0 interface.

**IP Address:**

`10.10.10.50`

**Subnet Mask**

`255.255.255.0`

**Command:**

`ip address 10.10.10.50 255.255.255.0`


The IP address allows the router interface to communicate with devices on the network.

---

## Step 8: Enable the Router Interface

Enable the interface using the following command:

**Command:**

`no shutdown`

This command activates the interface.

After entering the command, check whether the interface status changes to an active state.

---

## Step 9: Verify the Interface Configuration

Check the status of the router interfaces.

**Command:**

`show ip interface brief`

This command displays:

- Interface names
- Assigned IP addresses
- Interface status
- Protocol status

Locate the Gigabit Ethernet 0/0 interface and verify that its configuration is correct.

---

## Step 10: Test Connectivity Using Ping

Use the laptop to test communication with the router.

**Command:**

`ping 10.10.10.50`

A successful ping confirms that the laptop can communicate with the router's configured IP address.

Record whether the ping test succeeds or fails.

---

## Step 11: Test Connectivity Using Traceroute

Run a traceroute test from the laptop.

**Command:**

`tracert 10.10.10.50`

This command displays the network path used to reach the destination IP address.

The traceroute test was completed to verify network communication.

---
