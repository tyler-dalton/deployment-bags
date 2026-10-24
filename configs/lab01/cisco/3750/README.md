# Cisco Catalyst 3750 — Lab 01

The `lab01.cfg` file is the sanitized baseline for inventory device `SW01`
(`BG01-SW01`).

Physical port layout:

- `FastEthernet1/0/1`–`FastEthernet1/0/3`: student ports, access VLAN 1
- `FastEthernet1/0/4`–`FastEthernet1/0/22`: bricked, access VLAN 999, shutdown
- `FastEthernet1/0/23`: TA management, access VLAN 1
- `FastEthernet1/0/24`: Raspberry Pi server, access VLAN 1

Port `FastEthernet1/0/23` allows four authorized TA MAC addresses using the
`<TA_MAC_01>` through `<TA_MAC_04>` placeholders.

Use the [Cisco 3750 setup guide](../../../../docs/labs/lab01/setup/cisco-3750.md)
when creating or updating the baseline. Do not commit raw configuration
exports containing password hashes or private key material.
