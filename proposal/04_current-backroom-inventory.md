# NAVYA TODO:
- [ ] Fill out the [overview](#overview) section quantities.
- [ ] In the [routers section](#routers), add the two missing serial numbers.
- [ ] Get an inventory count on the [interface modules](#interface-modules). There are some on the second level of the shelf, and some in the routers in the bags, so make sure to count all.
- [ ] Fill out what you can find on the [Raspberry Pi](#end-devices) and the [wireless AP](#wireless). Do not get hung up on filling each field, just delete the ones you cannot fill. The tables right now are merely placeholders.

---

# Current Backroom Inventory

## Overview

| Category                | Equipment                         | Quantity |
| ----------------------- | --------------------------------- | -------- |
| Routers                 | Cisco 1941 Series                 |         |
| Routers                 | Cisco 2900 Series                 | 2        |
| Switches                | Cisco Catalyst 2960 Plus Series   | 1        |
| Switches                | Cisco Catalyst 3750 PoE Series    | 1        |
| Interface Modules       | Serial / HWIC modules             | 8        |
| Ethernet                | CAT 6                             | 16       |
| Physical Infrastructure | Deployment Bags                   | 2        |
| Power                   | Power strips / Rack-mounted power | 2        |
| End Devices             | PCs / Laptops / Endpoints         | 3        |
| Wireless                | Access Point                      | 1        |
| Misc.                   | Cable ties                        | 10       |

---

## Routers

| Asset ID | Manufacturer | Family | Exact Model | PID | Serial # | Built-In Interfaces | Installed Modules | Rack Size | Status | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| RTR-001 | Cisco | 2900 | Cisco 2911 | CISCO2911/K9 V07 | FJC1916A29A | 3 x Gb RJ45 | 3 x Serial WAN | 2u | Powers up |
| RTR-002 | Cisco | 1900 | Cisco 1941 | CISCO1941/K9 V05 | FJC1916E13Y | 2 x Gb RJ45 | 1 x Serial WAN | 2u | Powers up |

## Switches

| Asset ID | Manufacturer | Exact Model | PID | Serial # | IOS Version | Port Count | Port Speed | PoE | SFP Ports | Rack Size | Status | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| SW-001 | Cisco | Catalyst 3750 Series PoE-24 | W6-C3750-24PS-SVD5* | CAT1039ZG95 | 12.2(25)SEE2 | 24 | 1Gb | Yes | 2 | 1U | Powers up |
| SW-002 | Cisco | Catalyst 2960 Plus Series | Ws-C2960+24TC-L V01 | FOC1907Z1RB | 15.0(2)SE6 | 24 | 1Gb | No | 4 | 1U | Powers up |

## Interface Modules

| Manufacturer | Exact Model | PID | Serial # | Interface Type | Interface Count | Notes |
|---|---|---|---|---|---|---|
| Cisco | HWIC-2T | 800-34379-03 | FOC19028BWF | Serial | 2 | |
| Cisco | HWIC-2T | 800-34379-03 | FOC18525FU6 | Serial | 2 | |
| Cisco | HWIC-2T | 800-34379-03 | FOC19028C1G | Serial | 2 | |
| Cisco | HWIC-2T | 800-34379-03 | FOC19028BUM | Serial | 2 | |
| Cisco | HWIC-2T | 800-34379-03 | FOC19022Q1Y | Serial | 2 | X |
| Cisco | HWIC-2T | 800-34379-03 | FOC19028C2D | Serial | 2 | X |
| Cisco | HWIC-2T | 800-34379-03 | FOC19028C17 | Serial | 2 | X |
| Cisco | HWIC-2T | 800-34379-03 | FOC19028BZ8 | Serial | 2 | X |

## Ethernet

| Cable Type | Length | Quantity | Notes |
| ---------- | ------ | -------- | ----- |
| CAT 6      |        | 7        |       |
| CAT 5e     |        | 3        |       |
| CAT 5      |        | 1        |       |
| Unknown    |        | 5        |       |

## End Devices

| Asset ID | Device Type | Manufacturer | Exact Model | Serial # | Service Tag | PID | Status | Notes |
| --- |---|---|---|---|---|---|---|---|
| | Desktop | Lenovo | ThinkCentere M91p | MJBAHGK  | | 7033A1U |
| | Desktop | Dell | | | BYXBMS1 |
| | SBC | Raspberry Pi | Raspberry Pi 3 Model B+ | 

## Wireless

| Asset ID | Manufacturer | Exact Model | PID | Serial # | MAC | Ethernet Speed | PoE | Wi-Fi Standard | Management Method | Status | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
| AP-001 | Aruba Networks | AP-135 | IAP-135-US | AX0427715 |  |  | | 4 | IAP