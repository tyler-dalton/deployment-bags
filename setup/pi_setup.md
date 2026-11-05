# Raspberry Pi Setup Guide

This guide covers the full setup process for a lab Pi — from flashing the OS to running the game server. Follow the steps in order.

---

## Prerequisites

- Raspberry Pi (with SD card slot)
- SD card (16GB+ recommended)
- A laptop with internet access
- Power cable
- Monitor
- SD card reader/adapter
- Ethernet cable
- Access to internet (temporary, for setup only)

---

## Step 1 — Flash Ubuntu Server

1. Download [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
2. Insert the SD card into your laptop
3. Open Raspberry Pi Imager and select:
   - **OS:** Ubuntu Server (latest LTS, 64-bit)
   - **Storage:** your SD card
4. Change the default config to have the username **ta** and the management password
5. Click **Write** and wait for it to finish
6. Eject the SD card and insert it into the Pi

---

## Step 2 — Create User Account

1. Boot the Pi and log in with the default credentials.
2. Create student user:
   ```bash
   sudo adduser student
   ```
    Hit Enter to accept the default settings,
---

## Step 3 — Connect the Pi to the Internet (Temporary)

Plug the Pi into a wall port that has internet access. This is temporary — just long enough to update and install dependencies.

To connect to the internet temporarily, edit the following file using nano. Use this command to get there:
```bash
sudo nano \etc\netplan\50-cloud-init.yaml
```

Make sure that the configuration matches the following:
```
eth0:
  dhcp4: true
  optional: true
  ......
```

To apply the settings, use the following commands:

```
sudo netplan try
sudo netplan generate   
sudo netplan apply
```

Confirm connectivity:
```bash
ping google.com
```

---

## Step 4 — Update the Pi

Before proceeding further, reboot the machine using this command:

```
reboot
```

Then, update the pi:
```bash
sudo apt update && sudo apt upgrade -y
```

This may take a few minutes.

> [!IMPORTANT]
> Reboot after the upgrade completes before continuing — kernel updates won't take effect until you do.
> ```bash
> sudo reboot
> ```
> Wait for the Pi to come back up, then SSH back in before proceeding.


----

## Step 5 — Install Docker

```bash
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker --now
sudo usermod -aG docker $USER
```

> [!IMPORTANT]
> Log out and back in after adding yourself to the docker group before continuing to Step 9.
> ```bash
> exit
> ```
> Then SSH back in. This is required — skipping it will cause a permissions error in the next step.

If it asks you to reboot, reboot the machine using the command:
```
reboot
```
---

## Step 6 — Start the Server with Docker Compose

```bash
cd lan-games
docker compose up -d
```

Verify the containers are running:
```bash
docker ps
```

---

## Step 7 — Enable SSH


Confirm it's running:
```bash
sudo systemctl status ssh
```

If it's not, start using this command:
```bash
sudo systemctl enable ssh --now
```


---

## Step 9 — Verify the Server is Still Running

```bash
docker ps
```

If any containers stopped, bring them back up:
```bash
cd lan-games
docker compose up -d
```

Then confirm the server is reachable from another machine on the lab network:
```
ping 10.0.0.254
```

---

## Step 10 — Install Git

```bash
sudo apt install -y git
```

---

## Step 11 — Clone the Game Server Repo

```bash
git clone https://github.com/kbennett2000/lan-games.git
```

---

## Step 12 — Navigate to the Repo

```bash
cd lan-games
```

Copy the .env.example file to the .env file using the command:

```
cp .env.example .env
```
Build the docker container:
```
docker compose up -d
```

To verify that it is running, use the command:
```
docker compose ps -a
```

If it keeps restarting, shut down the docker container using the command:
```
docker compose down
```

Then use the up command again to start the container:
```bash
docker compose up -d
```

---

## Step 8 — Move Pi to the Lab Network

1. Unplug the Pi from the internet-connected switch
2. Set the static IP to `10.0.0.254`:

   Edit the network config:
   ```bash
   sudo nano /etc/netplan/50-cloud-init.yaml
   ```

   Set it to:
   ```yaml
   network:
     ethernets:
       eth0:
         dhcp4: false
         addresses:
           - 10.0.0.254/24
   ```

   Apply the config:
   ```bash
   sudo netplan try
   sudo netplan generate
   sudo netplan apply
   ```

   Confirm the change:
   ```
   ip addr
   ```

3. Plug the Pi into the lab switch


---

## Step 13 — Restrict Traffic to Port 3000 Only

Use `ufw` to allow only game server traffic in and out.

```bash
# Allow inbound SSH so you don't lock yourself out
sudo ufw allow in 22

# Allow inbound on port 3000 (students connecting to the game server)
sudo ufw allow in 3000

# Allow outbound on port 3000
sudo ufw allow out 3000

# Allow DNS outbound (needed for hostname resolution if Pi ever needs internet again)
sudo ufw allow out 53

# Allow NTP outbound (needed for system clock sync)
sudo ufw allow out 123/udp

# Allow established/related connections so active sessions aren't broken
# If there are no active connections, it would say that it could not find connection established
sudo ufw allow in established
sudo ufw allow out established

# Block everything else
sudo ufw default deny incoming
sudo ufw default deny outgoing

# Enable the firewall
sudo ufw enable
```

Verify the rules look correct:
```bash
sudo ufw status verbose
```

> [!IMPORTANT]
> The `sudo ufw allow in 22` line must be run **before** `sudo ufw enable`. Enabling the firewall without it will immediately drop your SSH connection and require a monitor and keyboard to recover.

> [!NOTE]
> If the game server uses additional ports beyond 3000, add them with `sudo ufw allow in <port>` and `sudo ufw allow out <port>` before enabling.

---
## Step 14:

### Shutting down the Raspberry Pi

Do not shut the Raspberry Pi down while the docker container is running, it can damage the writable layer. 

Shut the Raspberry Pi down first, using the comnand:
```
docker compose down
```

Shut the machine down:
```
shutdown now
```



## Setup Complete

The Pi is ready for the lab. Students should be able to reach the game server at `10.0.0.254:3000`.