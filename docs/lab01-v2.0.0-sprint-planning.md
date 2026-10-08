# Lab 01 v2.0.0 Sprint Planning

Emrah gave us 10 days, I want to get it done in ~7. I know this is ambitious, but it will keep us moving forward and keep things moving quick. We may not get it done in 7 and thats okay, but that is where I want to be shooting for.

## Overall Timeline

### Thursday, 10/08/2026

| Date | Description | Duration | Involved |
|---|---|
| [10/8 @ 1000-1030](#10-1030---grayson--tyler) | Arc. freeze. | ~30 min | Grayson + Tyler |
| [10/8 @ 1030-1200](#1030-1200---grayson) | Grayson work time. Pilot arc. See [todo](../action-items/grayson/10.08.todo.md). | 1.5hr | Grayson |
| [10/8 @ 1030-1145](#1030-1145---tyler) | Arc. Specs | ~1hr | Tyler |
| [10/8 @ 1145-1200](#1145-1200---grayson--tyler) | Sync-up | 15min | Grayson + Tyler |

### Friday, 10/09/2026

| [Friday, 10/9 @ whenever](#whenever---navya) | Linux confirmation | ? | Navya |

## Thursday, 10/08/26

### 10-1030 - Grayson + Tyler

Grayson + Tyler

Sit down and establish the architecture.

* VLAN 10 & VLAN 20 `(10.0.10.0/24 & 10.0.20.0/24)`
* VLAN 10 = ports `Fa0/1-Fa0/12` VLAN 20 = `Fa0/13-Fa0/23`
  * * Determine how many ports Juniper switches have, this could change the architecture.
* Port 24 failsafe management port
* What does "Reset to baseline" mean in this context?

### 1030-1200 - Grayson

Work time to pilot new arc onto one switch. Action items can be found in [your action-items folder](../action-items/grayson/10.08.todo.md). Be prepared to circle back at 1145 with current status. 1145 we will confirm any of the configuration that is currently implemented.

### 1030-1145 - Tyler

This is time used to clean up the architecture planning located in the [overview document](../docs/lab01-v2.0.0-overview.md).

### 1145-1200 - Grayson + Tyler

Sync up on what got done today. Confirm any configuration complete.

## Friday, 10/09/26

### Whenever - Navya

Confirm what is done on lab01 works for linux distributions. Check documentation and confirm all Linux commands are present & correct.
