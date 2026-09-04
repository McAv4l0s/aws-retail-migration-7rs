# Cutover Plan

**Time zone:** America/Mexico_City

**Program window:** May 15–June 23, 2026

**Stabilization completion:** June 26, 2026

## Master calendar

| ID | Wave | Workload | Strategy | Cutover window | Freeze | Success criterion | Rollback threshold |
|---|---|---|---|---|---|---|---|
| CO-01 | 1 | Legacy batch catalog | Retire | May 15, 21:00–23:00 | 20:00 | Archive reconciled and consumers redirected | Catalog variance > 0.5% |
| CO-02 | 2 | Auxiliary ERP | Rehost with MGN | May 22, 22:00–May 23, 02:00 | 21:00 | Critical UAT, integrations, and jobs correct | Sev-1, data loss, or > 30 min without progress |
| CO-03 | 3 | Inventory database | Replatform to RDS | May 29, 22:00–May 30, 03:00 | 21:00 | Reconciliation ≥ 99.99% and latency within SLO | Variance > 0.01% or p95 latency outside SLO for 15 min |
| CO-04 | 4 | CRM and VMware integrations | Repurchase / Relocate | June 12, 21:00–June 13, 02:00 | 20:00 | Cases, users, and primary flows approved | Critical integration fails for 30 min |
| CO-05 | 5 | Modernized checkout | Refactor | June 22, 22:00–June 23, 01:00 | 21:00 | Error rate, payments, and conversion within SLO | Error rate > 2% for 10 min or inconsistent payments |

## Window governance

| Role | Cutover responsibility |
|---|---|
| Cutover Manager | Directs the sequence, records times, and declares go/no-go |
| Business Owner | Authorizes interruption, validates critical processes, and accepts service |
| Application Owner | Runs smoke tests, UAT, and functional verification |
| Platform Lead | Executes infrastructure, network, observability, and traffic changes |
| Data Lead | Controls freeze, replication, reconciliation, and consistency |
| Security Lead | Oversees temporary access, findings, and evidence |
| Communications Lead | Updates stakeholders and the service desk |

## Mandatory checkpoints

### T-24 hours

- Change approved and owners confirmed.
- Backup and restoration verified.
- Replication, capacity, and observability healthy.
- Runbook and rollback rehearsed.
- No open critical incidents.

### T-60 minutes

- Open the command bridge and freeze changes.
- Confirm baseline metrics and escalation channels.
- Validate temporary credentials and emergency access.
- Record the preliminary go/no-go decision.

### T-0

- Stop writes according to the runbook.
- Confirm zero lag or lag within the approved threshold.
- Execute the change and record every timestamp.

### T+30 and T+60 minutes

- Run functional tests, integration tests, and reconciliation.
- Compare error rate, latency, volume, and transactions with the baseline.
- Decide acceptance, controlled extension, or rollback.

## Rollback rules

The Cutover Manager starts rollback when a table threshold is reached, transactions are lost or duplicated, a critical security finding appears, or insufficient time remains to complete testing within the window. The source remains available until formal acceptance.

For CO-02, **do not finalize cutover in MGN** until UAT, reconciliation, and approval are complete. Finalizing MGN stops replication and removes temporary replication resources, so that action belongs to closure, not the beginning of cutover.

## Closure evidence

- Go/no-go decision record.
- Start, change, validation, and closure timestamps.
- Smoke-test, UAT, and reconciliation results.
- Before-and-after metrics.
- Incidents, deviations, and open actions.
- Business Owner and Service Owner acceptance.
