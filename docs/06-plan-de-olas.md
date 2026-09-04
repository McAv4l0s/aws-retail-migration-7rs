# Wave Plan

**Program baseline:** May 2026

**Planned window:** May 4–June 26, 2026

| Wave | Planned window | Scope | Objective | Exit gate |
|---|---|---|---|---|
| 0 | May 4–8 | Landing zone, network, identity, and logs | Prepare secure operations | Controls and connectivity approved |
| 1 | May 11–15 | Catalog retirement and pilot workload | Reduce scope and validate the method | Reconciliation complete and support stabilized |
| 2 | May 18–22 | ERP rehost with MGN | Avoid hardware renewal | UAT, performance, and rollback approved |
| 3 | May 25–29 | Inventory replatform | Reduce database operations | Integrity, RPO, and performance approved |
| 4 | June 1–12 | CRM repurchase and integrations relocate | Complete the gradual exit | Contracts, data, and operations approved |
| 5 | June 15–22 | Checkout refactor | Improve scale and delivery speed | SLO and progressive deployment approved |
| Stabilization | June 23–26 | Hypercare, cost, security, and closure | Confirm benefits and operations | KPIs and executive acceptance |

## Cutover windows

| ID | Wave | Window | Service change |
|---|---|---|---|
| CO-01 | 1 | May 15, 21:00–23:00 | Legacy catalog retirement |
| CO-02 | 2 | May 22, 22:00–May 23, 02:00 | ERP cutover through MGN |
| CO-03 | 3 | May 29, 22:00–May 30, 03:00 | Inventory to Amazon RDS |
| CO-04 | 4 | June 12, 21:00–June 13, 02:00 | SaaS CRM and relocated integrations |
| CO-05 | 5 | June 22, 22:00–June 23, 01:00 | Progressive traffic to the new checkout |

Detailed operations, checkpoints, and rollback thresholds are in [`10-plan-de-cutover.md`](10-plan-de-cutover.md).

## Common gates

- Go/no-go signed by business, application, infrastructure, and security owners.
- Change freeze active and backup verified.
- Observability and command bridge active.
- Critical tests completed.
- Rollback thresholds quantified.
- Financial and licensing validation complete.

## Rollback

Rollback is triggered by lost or inconsistent orders, a sustained error rate above the SLO, degradation that cannot be mitigated within the window, or a security breach. The source remains available until acceptance, and concurrent writes that cannot be reconciled are prevented.
