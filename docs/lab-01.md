# Cisco Networking Lab Documentation

## September 15, 2026

### Equipment Setup

- Located the **Cisco 1941 router**
- Connected the **Cisco 1941 router to power**
- Connected the **Tripp Lite power protection unit**
  - Used to provide power protection for the networking equipment.

### Network Cable Connections

- Connected a **Cat5e Ethernet cable** from the Cisco 1941 router's **GigabitEthernet 0/0 (GE 0/0)** port to **Switch Port 1**.
- Connected a second **Cat5e Ethernet cable** from **Switch Port 2** to the PC.
- Connected a **console cable** from the console port on the Cisco 1941 router to the PC.
  - Connected the router-side connector to the router's console port.
  - Connected the USB end to the PC.

### Power & Connectivity Verification

-  Powered on the **Cisco 1941 router**.
- Powered on the **switch**.
- Verified that the **link/activity lights** were on.
- Confirmed that the physical network connections were active.

### Console Access

- Attempted to use **PuTTY** to establish a console connection.
- Experienced connection issues with PuTTY.
- Switched to **Tera Term** as an alternative terminal program.
- Successfully established a console connection to the **Cisco 1941 router**.
- Successfully accessed the router's **Cisco IOS command-line interface (CLI)**.

### Network Layout

```text
Cisco 1941 Router
       |
       | Cat5e
       | GE 0/0
       v
   Switch Port 1
       |
       | Cat5e
       | Switch Port 2
       v
      PC

Cisco 1941 Router
       |
       | Console Cable
       v
      PC
