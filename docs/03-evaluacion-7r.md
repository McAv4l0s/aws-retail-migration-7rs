# 7 Rs Assessment

## Decision method

Each workload receives a score from 1 to 5 for business value, urgency, technical risk, dependency complexity, operational readiness, and modernization potential. The selected R is not permanent: it is reviewed when discovery and testing produce new evidence.

| Workload | R | Business rationale | Technical rationale | Primary gate |
|---|---|---|---|---|
| Batch catalog | Retire | Duplicate function | Unsupported components | Reconciliation and archive approved |
| POS | Retain | High store risk | Peripheral and network dependencies | Edge strategy defined |
| Auxiliary ERP | Rehost | Hardware deadline | Compatible with replication to EC2 | MGN test and licensing approved |
| VMware integrations | Relocate | Rapid site exit | Minimal hypervisor change | Compatibility and connectivity |
| CRM | Repurchase | Not a business differentiator | SaaS meets requirements | Data migration and contracts |
| Inventory | Replatform | Lower operational burden | Engine compatible with RDS | Performance and reconciliation |
| Checkout | Refactor | Revenue differentiator | Monolith limits scaling | SLO, tests, and strangler pattern |

## Sequence

The classification does not mean executing seven movements simultaneously. Retire and repurchase reduce scope; retain controls risk; rehost and relocate accelerate exit; replatform and refactor are scheduled when the platform and team are ready.
