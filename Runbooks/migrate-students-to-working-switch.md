# Migrate Students to Working Switch (RB04)

This runbook covers diaster recover for when one switch or multiple switches have been deemed unusable.

* Identify the affected students PC UID's
* Instruct the students to move to the port on the new switch dedicated to their endpoint

With the existing architecture, endpoints can freely move between switches as needed. The correct port-security is already configured, all that needs to be done is changing ports to the new switch.

## Verification

* Run `ipconfig /all`, ensure that IPv4 settings were retained
* Ping the new switch IP: `ping 10.0.0.1`
* Ping the new server: `ping 10.0.0.254`

**Do not return the failed switch back into service until it has been validated.**
