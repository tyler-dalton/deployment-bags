# Lab 01 switch configurations

Configurations are separated by vendor, model, and physical switch:

```text
configs/lab01/
├── cisco/
│   ├── 2960/
│   │   └── lab01.cfg
│   └── 3750/
│       └── lab01.cfg
└── juniper/
    └── ex3300/
        ├── sw03/
        │   └── lab01.conf
        └── sw04/
            └── lab01.conf
```

The two Juniper files are sanitized Junos `set`-format baselines for the
physical switches `BG02-SW03` and `BG02-SW04`. Credentials are intentionally
omitted and must be configured through the approved secure deployment process.

The Cisco directories contain sanitized model-specific baselines:

| Directory | Hardware | Inventory ID | Hostname | Setup documentation |
| --- | --- | --- | --- | --- |
| `cisco/2960/` | Catalyst WS-C2960+24TC-L | `SW02` | `BG01-SW02` | [Cisco 2960 setup](../../docs/labs/lab01/setup/cisco-2960.md) |
| `cisco/3750/` | Catalyst WS-C3750-24PS-S | `SW01` | `BG01-SW01` | [Cisco 3750 setup](../../docs/labs/lab01/setup/cisco-3750.md) |
| `juniper/ex3300/sw03/` | Juniper EX3300-24P | `SW03` | `BG02-SW03` | [Juniper setup](../../docs/labs/lab01/setup/juniper.md) |
| `juniper/ex3300/sw04/` | Juniper EX3300-24P | `SW04` | `BG02-SW04` | [Juniper setup](../../docs/labs/lab01/setup/juniper.md) |

Every switch uses the same physical role layout:

| Physical ports | Role | VLAN | State |
| --- | --- | --- | --- |
| 1–3 | Student endpoints | 1 (default) | Enabled |
| 4–22 | Bricked/unused | 999 | Administratively down |
| 23 | TA management, four authorized MAC addresses | 1 (default) | Enabled |
| 24 | Raspberry Pi server | 1 (default) | Enabled |

Do not add raw switch exports to this directory. Remove password hashes,
private keys, SNMP communities, and other secrets before committing a
configuration. A repository configuration is a reviewable template; an exact
restoration backup belongs in the approved secure storage for the deployment
bags.
