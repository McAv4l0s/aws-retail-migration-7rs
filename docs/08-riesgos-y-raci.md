# Risks and RACI

## Risk register

| ID | Risk | Probability | Impact | Mitigation | Owner |
|---|---|---:|---:|---|---|
| R-01 | Undiscovered dependency | 3 | 5 | Telemetry, interviews, and wave testing | Application Owner |
| R-02 | Inventory inconsistency | 3 | 5 | CDC/reconciliation and freeze | Data Owner |
| R-03 | Cost above the business case | 3 | 4 | Budgets, rightsizing, and weekly review | FinOps |
| R-04 | Excessive access during migration | 2 | 5 | Temporary roles and auditing | Security Owner |
| R-05 | Cutover during a critical commercial period | 2 | 5 | Blackout calendar and go/no-go | Business Owner |
| R-06 | Non-portable license | 3 | 4 | Prior contractual validation | Procurement |

Scale: 1 low, 5 high. Risks with probability × impact ≥ 12 require a plan and executive acceptance.

## Summary RACI

| Activity | Business | Program | App | Platform | Security | FinOps |
|---|---|---|---|---|---|---|
| Approve scope and KPIs | A | R | C | C | C | C |
| Classify 7 Rs | C | A | R | R | C | C |
| Design landing zone | I | A | C | R | R | C |
| Approve cutover | A | R | R | R | C | I |
| Accept risk | A | R | C | C | R | C |
| Validate benefits | A | R | C | I | I | R |

R = responsible, A = accountable, C = consulted, I = informed.
