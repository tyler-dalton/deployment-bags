! ============================================
! SWITCH 1 CONFIGURATION
! Management IP: 10.0.0.1
! DHCP Server, WAP on Fa0/23, Uplink on Fa0/24
! ============================================

enable
configure terminal

! --- Hostname ---
hostname SW1

! --- Enable Secret ---
enable secret YourStrongPassword

! --- Management IP on VLAN 1 ---
interface vlan 1
 ip address 10.0.0.1 255.255.255.0
 no shutdown
 exit

! --- Default Gateway (no router, but good practice) ---
ip default-gateway 10.0.0.1

! --- DHCP Pool ---
ip dhcp excluded-address 10.0.0.1 10.0.0.9
ip dhcp pool LAN
 network 10.0.0.0 255.255.255.0
 default-router 10.0.0.1
 dns-server 8.8.8.8
 lease 7

! --- Access Ports (Fa0/1 - Fa0/22) Wired Endpoints ---
interface range Fa0/1 - 22
 switchport mode access
 switchport access vlan 1
 spanning-tree portfast
 no shutdown
 exit

! --- WAP Port (Fa0/23) ---
interface Fa0/23
 switchport mode access
 switchport access vlan 1
 spanning-tree portfast
 no shutdown
 exit

! --- Uplink to Switch 2 (Fa0/24) ---
interface Fa0/24
 switchport mode trunk
 no shutdown
 exit

! --- SSH Setup ---
ip domain-name lan.local
crypto key generate rsa modulus 2048
ip ssh version 2
username admin privilege 15 secret YourStrongPassword

! --- Console Access ---
line console 0
 login local
 exit

! --- VTY (SSH) Access ---
line vty 0 15
 login local
 transport input ssh
 exit

! --- Save ---
end
write memory
