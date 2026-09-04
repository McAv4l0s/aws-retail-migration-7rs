# AWS Well-Architected Review

| Pillar | Initial risk | Decision | Expected evidence |
|---|---|---|---|
| Operational Excellence | Manual runbooks and incomplete ownership | IaC, CI/CD, owners, and game days | Pipeline, ADRs, runbooks, and postmortems |
| Security | Persistent access and fragmented logs | Federation, least privilege, encryption, and centralized logs | Policy checks, trails, and findings |
| Reliability | Recovery not rehearsed | Multi-AZ by criticality, backups, and testing | Restore report and RTO/RPO metrics |
| Performance Efficiency | Fixed capacity for peaks | Testing, scaling, and queues | Load test and utilization |
| Cost Optimization | No product-level cost | Tags, budgets, rightsizing, and unit economics | Cost-per-order report |
| Sustainability | Idle environments | Scheduled shutdown and managed services | Avoided hours and utilization |

## Open high risks

1. ERP dependencies have not been observed through a complete commercial cycle.
2. Inventory RPO has not been validated through order reconciliation.
3. The operator and vendor identity model still requires approval.
4. Peak cost lacks a representative load test.

The review is repeated before production and 30 days after every wave. Every risk must have an owner, date, and closure criterion.
