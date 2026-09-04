# Business Case

## Drivers

| Driver | Current consequence | Enabled capability |
|---|---|---|
| Seasonal growth | Saturation and overprovisioning | Demand-based scaling |
| Hardware renewal | Non-differentiating investment | Flexible consumption and gradual exit |
| Manual recovery | Potential lost sales | Automated and practiced recovery |
| Monthly releases | Slow market response | CI/CD and decoupled changes |
| Shared costs | Low product-level visibility | Tagging, budgets, and unit cost |

## Financial model

The analysis compares a 36-month horizon:

`TCO = migration + cloud + licenses + support + connectivity + operations + contingency`

`Net benefit = avoided costs + productivity + incident reduction - incremental TCO`

`ROI = net benefit / program investment`

No organization-specific amounts are published. A future workbook will use editable assumptions, show demand sensitivity of ±20%, and separate avoided CAPEX from operating savings.

## Benefits and owners

| Benefit | Indicator | Owner | Frequency |
|---|---|---|---|
| Sales continuity | Availability and failed orders | Head of Digital | Weekly/monthly |
| Recovery | Tested RTO/RPO | Service Owner | Quarterly |
| Speed | Lead time and deployment frequency | Engineering Manager | Per release |
| Efficiency | Cost per order | FinOps + Product Owner | Monthly |
| Risk | Open critical findings | Security Owner | Weekly |

## Exclusions

- Immediate POS replacement.
- Migration of real personal data into the laboratory.
- Simultaneous ERP and financial-process change.
- Savings commitments without a baseline and transaction volume.
