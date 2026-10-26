# Lab 01 Day - Setup Guide

## Equipment Checklist

### Each Bag (2) should have...
 
- [ ] Switches - 2
- [ ] Power source / strip - 1
- [ ] AC power - 2
- [ ] Raspberry Pi - 2
- [ ] Raspberry Pi Power - 2
- [ ] Ethernet cables - 8 (2 for the Pi's, 6 for endpoints
- [ ] Endpoints - 6
 
### The Cart should have...

- [ ] Cold-spare Raspberry Pi
- [ ] Spare Pi power
- [ ] Spare AC power - 2
- [ ] Spare Ethernet cables
- [ ] Console cables - 2
- [ ] Computer chargers
- [ ] TA ThinkPad

## Setup

First verify that all equipment is turned on, navigate to each switch and plug into the management port (23) on each switch. SSH into the Pi `(10.0.0.254)` and start the lan-games server:

### SRV01

```bash
cd lan-games/server

export JWT_SECRET=$(node -e "process.stdout.write(require('crypto').randomBytes(48).toString('hex'))")
npm start
```

### SRV02,03,04

```bash
cd lan-games

sudo docker compose up -d
```


## After the lab
- [ ] Static IP and arp cache has been removed on the laptops
