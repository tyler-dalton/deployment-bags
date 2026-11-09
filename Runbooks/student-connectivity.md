# Student Connectivity Troubleshooting (RB02)

## Discovery

* Confirm Ethernet link lights on both endpoint and switch
* Run `ipconfig /all` and verify:
  * IP: `10.0.0.x`
  * Subnet: `255.255.255.0`
  * Gateway: `10.0.0.1`
  * Ensure that the IP address is not `169.254.x.x` this is an auto-assigned IP from Windows indicating conflicting IP addresses
* Connectivity:
  * Switch: `ping 10.0.0.1`
  * Server: `ping 10.0.0.254`
  * Container: [http://10.0.0.254:3000] in browser

Use this information to understand where the possible failure is occurring.

## Decision Table

| Observation | Action |
| --- | --- |
| No Ethernet link lights | Reseat cable -> replace cable -> try different port |
| Ping returns `General Failure` | Verify IP settings |
| IP is incorrect or `169.254.x.x` | Reapply assigned static IP, ensure no duplicate conflicts |
| One student lacks connectivity | Check duplicate IP, cable, switch port |
| Multiple students lack connectivity | Check switch interfaces, uplinks -> [RB04](./migrate-students-to-working-switch.md) |
| Can ping switch, not server | Check Raspberry Pi power, Ethernet, IP |
| Can ping server, webpage fails | Check Docker container -> [RB03](./lan-games-container-recovery.md) |
