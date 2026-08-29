# Project Objectives

The primary objective of the **IT1080C Deployment Bags** is to design and develop a standardized, isolated, and maintainable networking environment that supplements the existing IT1080C course structure implemented.

Success can be measured on the following objectives:

**1. Bridge simulation and physical implementation**
	Extend the current Packet Tracer learning by giving students opportunities to deploy networking concepts on physical Cisco routers and switches. The physical labs should be designed to co-exist with the current simulation-based curriculum, not replace it.
**2. Provide hands-on experience with enterprise networking equipment**
	Give students exposure to physical routers, switches, and cabling. Students can use experiences like this as great talking points throughout the internship process.
**3. Create standardized student deployment environments**
	Establish a canonical Deployment Bag configuration so that user experience stays consistent through shifts in labs and instruction management. Labs should be designed against this standard as close as possible to ensure minimal movement of equipment.
**4. Maintain complete isolation from the UC production network**
	Ensure the environment operates independently from the UC production infrastructure. Student deployments must not require, nor have access to the production network in order to function. The designed environment must prevent student deployments from affecting any University systems.
**5. Minimize reset & configuration overhead**
	Develop documented baseline configurations and a repeatable reset process. Equipment should have the ability to return to a predictable state between labs or misconfigurations without extensive manual reconfiguration.
**6. Design for future expansion & reuse**
	Build the platform around reusable and portable infrastructure rather than a single-set of labs. The architecture should permit additional Deployment Bags and new or more advanced labs without requiring the environment to be redesigned from the ground-up.

---
# Scope / Out of Scope

Project scope is constrained to concepts appropriate to the IT1080C course structure and to an isloated lab environment. The platform should provide enough meaningful learning while remaining safe and maintainable.

## In Scope
- **Physical networking & ethernet**: Students will work directly with enterprise switching and ethernet cabling.
- **Layer 2 switching**: Labs may cover MAC addressing, forwarding behavior, and understanding of the relationship between layers 1 and 2 of the TCP/IP model.
- **VLAN segmentation**: Physical switches will demonstrate how multiple networks can be constructed over shared networking infrastructure.
- **Spanning Tree Protocol**: Students may construct redundant layer 2 topologies and observe STP behavior that is currently being demonstrated in Packet Tracer.
- **IPv4 addressing & subnetting**: Students will configure:
	- Network interfaces
	- Subnet masks
	- Default gateways
	- Multiple IP networks
- **Routing & packet forwarding**: Labs may require students to connect multiple networks through routers. Students may observe routing tables and next-hop forwarding.
- **Static and introductory to dynamic routing**: The environment will support manually configured routes as well as dynamic-routing labs. This allows students to observe how routers change forwarding information as topology changes.
- **DHCP and network services**: Students may configure or interact with DHCP infrastructure and investigate DHCP behavior across subnets covering concepts such as DHCP relay.
- **Isolated WAN simulation**: Routers may be interconnected through dedicated serial interface modules to represent a WAN connection. This connection will entirely simulate a WAN interface while removing the UC production network from the deployment topology.

## Potential Future Scope
- **Challenge boxes and incident response scenarios** could introduce intentionally misconfigured networks that students must diagnose with limited, ambiguous information. This will give students experience in incident response as it is done in enterprise environments, also simulating a non-technical manager assigning a task that they are not fully familiar with. 

## Explicitly Out of Scope
- **UC production network connectivity**. Student environments should interact with a simulated WAN connection if applicable, and stay isolated from UC Secure. The lab environment will not connect or route traffic to the production network.