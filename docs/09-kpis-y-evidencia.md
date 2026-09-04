# KPIs and Evidence

## Traceability rule

Every figure is labeled as a baseline, target, laboratory measurement, or operational result. A target is never presented as a result without evidence.

| KPI | Formula | Source | Cadence | Repository evidence |
|---|---|---|---|---|
| Availability | successful requests / total requests | Application metrics | Monthly | Anonymized export |
| RTO | restoration - incident start | DR exercise | Quarterly | Game-day report |
| RPO | last recovered data vs. interruption | Database/reconciliation | Quarterly | Restore report |
| Lead time | production - approved commit | CI/CD | Per release | Workflow history |
| Cost per order | attributable cost / completed orders | Billing + business | Monthly | FinOps model |
| Change failure rate | deployments with incidents / deployments | ITSM + CI/CD | Monthly | Release record |

## Initial project evidence

- Automated Terraform format and syntax validation.
- Version-controlled inventory of 7 Rs decisions.
- Reviewable as-is and to-be diagrams.
- MGN runbook covering testing, cutover, and rollback.
- Risk register with named owners.

Load tests, restore tests, and execution screenshots will be added when a deployable sandbox environment is available.
