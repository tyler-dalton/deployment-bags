
# Instructions to troubleshoot SSH

## How to SSH into the Raspberry Pi

The Raspberry Pi uses the lab network address `10.0.0.254` and the
standard SSH port (`22`).

1. Connect the Pi to the documented Raspberry Pi switch port and verify
   that it has power and Ethernet link lights.
2. From the laptop, confirm that the laptop is on the `10.0.0.0/24`
   network:

   ```text
   Windows:  ipconfig
   ```

   The laptop should have a `10.0.0.x` address other than `10.0.0.254`.
3. Test basic reachability:

   ```bash
   ping 10.0.0.254
   ```

4. Start the SSH session:

   ```bash
   ssh ta@10.0.0.254
   ```

   Accept the host-key prompt only when the address is known to be the
   deployment-bag Raspberry Pi, then enter the management password.

For more connection detail, add verbose output:

```bash
ssh -v ta@10.0.0.254
```

## What to do if it doesn't work

| Symptom | Checks and action |
| --- | --- |
| `Destination Host Unreachable` or no ping reply | Check Pi power, Ethernet cables, switch port, and laptop IP settings. Confirm the laptop is not using `169.254.x.x`. |
| Ping works but SSH says `Connection refused` | Use a console session or local keyboard and run `sudo systemctl status ssh`. Start it with `sudo systemctl enable --now ssh`. |
| `Connection timed out` | Check the Pi address with `ip addr`, confirm the cable is connected to the lab switch, and verify that the firewall allows SSH: `sudo ufw status verbose`. |
| `Permission denied` | Confirm the username is `ta`, re-enter the management password, and check keyboard layout or Caps Lock. Do not repeatedly guess passwords. |
| `REMOTE HOST IDENTIFICATION HAS CHANGED` | Stop and verify that the Pi was replaced or reimaged. If the replacement is expected, remove only the old entry with `ssh-keygen -R 10.0.0.254`, then connect again. |
| SSH disconnects after the firewall is enabled | From the Pi console, run `sudo ufw allow in 22`, then check `sudo ufw status verbose`. |

If the Pi has no local console access, isolate the failure from the laptop:

```bash
ping 10.0.0.1       # lab switch management address
ping 10.0.0.254     # Raspberry Pi
```

If the switch responds but the Pi does not, focus on the Pi's power,
Ethernet connection, static address, and network configuration. If neither
address responds, troubleshoot the laptop, cable, or switch port first.

After connecting, verify the game server separately:

```bash
docker ps
curl http://10.0.0.254:3000
```

SSH access can work even when the game container is stopped. For a stopped
or restarting container, see the
[LAN games container recovery runbook](../docs/labs/lab01/runbooks/lan-games-container-recovery.md).
