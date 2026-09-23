# Cisco Networking Lab - Reset Procedure

## Purpose

This guide explains how to reset the networking equipment after a student group finishes using it. The goal is to make sure the next group starts with a clean setup and that the professor can reset each bag without spending unnecessary time troubleshooting.

This procedure focuses on the Cisco 1941 router and the network switch.

## Equipment

- Cisco 1941 Router
- Network Switch
- Tripp Lite Power Protection Unit
- Console Cable
- Ethernet Cables
- Computer with Tera Term or PuTTY

---

## Step 1: Check the Equipment

Before resetting anything, make sure the equipment is connected and powered on.

1. Check that the Cisco 1941 router is connected to the Tripp Lite power protection unit.
2. Check that the network switch is connected to power.
3. Make sure the router and switch are powered on.
4. Check that the Ethernet cables are plugged in correctly.

The standard cable setup is:

- Router GE 0/0 → Switch Port 1
- Switch Port 2 → PC
- Router Console Port → Console Cable → PC

Check the link/activity lights to make sure the physical connections are working.

---

## Step 2: Connect to the Router

You will need to connect to the router using a console cable.

1. Plug the console cable into the console port on the front of the Cisco 1941 router.
2. Connect the USB end of the console cable to the computer.
3. Open Tera Term or PuTTY.
4. Select the COM port assigned to the console cable.
5. Set the baud rate to `9600`.
6. Open the connection.
7. Press Enter if the router prompt does not appear.

The router should display a prompt similar to:

Router>

Type `enable` to enter privileged EXEC mode.

The prompt should change to:

Router#

---

## Step 3: Check the Current Configuration

Before resetting the router, check whether the previous group left any configuration behind.

From privileged EXEC mode, enter:

`show running-config`

This displays the configuration currently being used by the router.

The professor can review the configuration to make sure the router is ready to be reset.

---

## Step 4: Erase the Router Configuration

**NOTE** This step will remove the saved configuration from the router. Make sure the previous group's work is no longer needed before continuing.

1. Confirm that the router is in privileged EXEC mode.
2. Enter the following command:

`erase startup-config`

3. Confirm the deletion when prompted.
4. Wait for the router to confirm that the startup configuration has been erased.

This removes the saved configuration that the router loads when it starts.

---

## Step 5: Restart the Router

After erasing the startup configuration, restart the router.

1. Enter:

`reload`

2. When asked whether to save the configuration, select **No**.
3. Confirm the reload when prompted.
4. Wait for the router to finish restarting.

Do not disconnect the router while it is restarting.

---

## Step 6: Handle the Initial Configuration Dialog

After the router restarts, it may ask whether you want to enter the initial configuration dialog.

If the goal is to leave the router unconfigured:

1. Select **No**.
2. Press Enter if needed.
3. Wait for the router prompt to appear.

The router should now be ready for the next student group.

---

## Step 7: Reset the Switch ONLY IF NEEDED

The switch must be reset separately from the router.

The exact commands depend on the switch model.

1. Identify the switch model.
2. Connect to the switch console.
3. Review the current configuration.
4. Follow the reset procedure for that switch model.
5. Verify that the previous group's configuration has been removed.

**Do not assume that resetting the router also resets the switch.**

---

## Step 8: Check the Equipment

After resetting the router and switch, check that everything is ready for the next group.

- [ ] Router is powered OFF.
- [ ] Switch is powered OFF.
- [ ] Ethernet cables are disconnected correctly.
- [ ] Link/activity lights are off as expected.
- [ ] Router configuration has been reset.
- [ ] Switch configuration has been reset.
- [ ] Console cable is available.
- [ ] Equipment is ready for the next group.
- [ ] The deployment bag should look exactly how it was when you first obtained it.

---

## Step 9: Final Check

Before giving the bag to the next group, you should make sure:

1. The router has been reset.
2. The switch has been reset.
3. The cables are connected correctly.
4. The equipment is powered on.
5. The router can be accessed through the console.
6. No configuration from the previous group remains.
7. Everything has been unplugged and put back correctly.

Once these steps are complete, the networking bag is ready for the next group.
