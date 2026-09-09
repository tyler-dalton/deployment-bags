# Executive Summary
The **IT1080C Deployment Bags** is a proposed expansion to the Computer Networking course designed to take theory of building virtual networks in Cisco Packet Tracer and bridge into hands-on enterprise networking experience. IT1080C currently combines networking theory with tangible experience using a Raspberry Pi lab, and virtual tools like Cisco Packet Tracer and Wireshark. There are two major takeaways from a movement to phsyical architecture:

1. Students get real experience with real equipment
2. Deployment Bags become a spark for students to find true interest in Networking/IT

This inititave introduces a set of **portable, standardized networking bags**. Rather than replacing the course's current Packet Tracer curriculum, students first learn the theory virtually, then have the opportunity to apply the concepts to real infrastructure. 

Each student Deployment Bag would provide a repeatable base platform containing the equipment required to complete a selection of lab exercises. A separate **management/infrastructure Deployment Bag** would provide students with an isolated and simulated WAN connection when appropriate for the scope of the lab. Together these bags will create a *completely isolated environment from the UC production network*. Through this isolated environment, students can configure devices, and troubleshoot failures with tangible hardware. 

A central constraint is **complete isolation from the UC production network**. The environment will operate like a 100% independent network with no dependency or ability to access production infrastructure. This isolation also allows a larger freedom to deploy intentional misconfigurations in a low-stakes environment.

The deployment model is intended to be **repeatable, recoverable, and scalable**. Documented standardized inventories, hardware configurations, and topology will mitigate drift between bags and ensure a consistent experience for each student. A defined reset procedure would also allow for seamless configuration wipes and movement between labs.

Longer term, the platform could provide a pathway for more advanced exercises in areas such as WAN simulation and multi-router networks. There is also the opportunity to design **controlled failure scenarios** where students can have the experience of incident response in network infrastructure.

The goal of the initiative is not to simply add hardware into the course - but to create a **maintainable platform** where students can progress from learning networking via simulation to physically implementing it. The project is currently leveraging as much existing equipment as possible in order to shrink investment costs until a sustainable pilot prototype has been deemed successful.