# Active Constraints and Design Requirements

| Priority | Classification | Requirement | Design Requirement / Acceptable Criteria |
| -------- | -------- | -- | ------ |
| P0 | Safety | Production network isolation | The lab environment must have **no routed, switched, wireless, or other physical connection to UC production infrastructure**. Lab operation must not depend on a UC Secure upstream. |
| P0 | Saftey | Infrastructure protection  | Students must be able to misconfigure, troubleshoot, erase and rebuild labs without harming the UC production infrastructure. |
| P1 | Operational | Repeatable known baseline | Every deployment bag must have a documented baseline configuration along with a procedure to restoring the equipment back to that state. |
| P2 | Operational | Rapid turnover during reset | Reset procedures should minimize the time and manual effort required to prepare equipment for another lab or exercise. |
| P2 | Physical | Portability via Deployment Bag form factor | All hardware must fit within the Deployment Bag 5U design. |
| P1 | Technical | Standardized environments | Deployment Bags of the same type should provide the same level of functionality to the best of the ability that the inventory permits. |
| P1 | Operational | Maintainable instructor/TA operation | Deployment and reset validation must be documented so that future TAs and instructors can operate the environment at the same operational level as someone who piloted the project.       |
| P2 | Resource | Cost/Inventory | For the pilot exercise, University-owned equipment should be used wherever possible. New purchases should be limited to mitigating performance gaps or significant operational resources. |
| P1 | Instructional | Curriculum alignment with IT1080C | Initial labs should reinforce the same topics already taught in the IT1080C course structure. |
| P1 | Instructional | Appropriate Accessibility | Exercises must assume that the networking knowledge of an IT1080C student has the ability to conceptualize, and complete without extreme assistance. |
| P1 | Documentation  | Sustainability and project continuity through documentation | Hardware inventories, topology diagrams, port mappings, reset procedures, deployment instructions. |

## Requirement Priority

| Priority | Meaning |
|----------|---------|
| P0 - Mandatory | Cannot be violated. A design that fails a P0 requirement in unacceptable |
| P1 - Required | Must be satisfied for the initial project to be considered successful |
| P2 - Preferred | Strong design preference, but compromises are acceptable when needed |
| P3 - Future-Oriented | Should influence design where practical but is not required for the initial deployment |
