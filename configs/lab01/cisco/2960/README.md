# Cisco Catalyst 2960 — Lab 01

The `lab01.cfg` file is the sanitized baseline for inventory device `SW02`
(`BG01-SW02`).

Physical port layout:

- `FastEthernet0/1`–`FastEthernet0/3`: student ports, access VLAN 1
- `FastEthernet0/4`–`FastEthernet0/22`: bricked, access VLAN 999, shutdown
- `FastEthernet0/23`: TA management, access VLAN 1
- `FastEthernet0/24`: Raspberry Pi server, access VLAN 1

Port `FastEthernet0/23` allows four authorized TA MAC addresses using the
`<TA_MAC_01>` through `<TA_MAC_04>` placeholders.

Use the [Cisco 2960 setup guide](../../../../docs/labs/lab01/setup/cisco-2960.md)
when creating or updating the baseline. Do not commit raw configuration
exports containing password hashes or private key material.
