# AWS Transform MGN Operating Model

This document covers the functions visible in the AWS Transform MGN menu and connects them to Wave 2 and cutover CO-02. MGN is regional: confirm the target account and region before operating.

## Console coverage

| View | Use within the program | Owner | Minimum evidence | Gate |
|---|---|---|---|---|
| Source servers | Register and monitor servers, replication, alerts, and lifecycle | MGN Operator | Inventory, lag, backlog, and status | Servers are `Ready for testing` |
| Applications | Group ERP servers as a business unit | Application Owner | Application, tags, and dependencies | All associated servers are healthy |
| Waves | Associate applications with Wave 2 and run coordinated actions | Migration Factory Lead | Wave, window, and aggregate status | Wave approved for test/cutover |
| Global view | Monitor member accounts when AWS Organizations is used | Cloud Platform Lead | Linked accounts and permissions | Cross-account inventory reconciled |
| Launch history | Audit tests, cutovers, terminations, and errors | Cutover Manager | Job ID, timestamps, status, and log | Job completed with no open errors |
| MGN connectors | Automate prerequisites, credentials, and agent installation | Source Infrastructure Lead | Connector, `Last seen`, servers, and command history | Connector healthy and access tested |
| Import | Create or update servers, applications, waves, and launch settings through CSV | Migration Planner | File, import job, and row errors | Import completed and reconciled |
| Export | Obtain a consolidated inventory for review and evidence | PMO / Migration Planner | Exported CSV and export history | File reconciled with the plan |

## Source servers

The main page lists the servers added to MGN. Filters can show active servers, discovered servers without an agent, imported servers without an agent, or archived servers.

### Wave 2 inventory

| Program server ID | Function | Platform | Application | Required status before test |
|---|---|---|---|---|
| ERP-WEB-01 | Internal frontend | Linux | ERP-Auxiliary | Healthy / Ready for testing |
| ERP-APP-01 | ERP services | Windows | ERP-Auxiliary | Healthy / Ready for testing |
| ERP-BATCH-01 | Jobs and integrations | Linux | ERP-Auxiliary | Healthy / Ready for testing |

For every server, review alerts, lag, backlog, disks, replication settings, launch settings, post-launch settings, tags, and lifecycle. A `Lagging` or `Stalled` server blocks go/no-go until the cause is investigated.

## Applications

The `ERP-Auxiliary` application groups the three Wave 2 servers. The application view is used to monitor aggregate alerts, replication status, and lifecycle, and to run tests or cutover against a coherent unit.

Minimum tags:

| Tag | Value |
|---|---|
| Portfolio | c2kmig |
| Wave | wave-02 |
| Application | ERP-Auxiliary |
| BusinessOwner | Finance-Fulfillment |
| Environment | production |
| CutoverId | CO-02 |

## Waves

MGN groups applications and servers into logical waves for monitoring and bulk actions. The technical MGN wave must match the program schedule:

| Field | Value |
|---|---|
| Wave | `wave-02-erp-rehost` |
| Test window | May 19, 2026, 20:00–23:00 |
| Cutover window | May 22, 22:00–May 23, 02:00 |
| Cutover ID | CO-02 |
| Entry criterion | Healthy replication, test completed, and UAT approved |
| Exit criterion | Cutover accepted, evidence complete, and application stable |

Operating sequence:

1. Start replication.
2. Confirm initial synchronization and healthy CDP.
3. Launch test.
4. Run smoke, integration, performance, security, and UAT tests.
5. Mark as ready for cutover.
6. Confirm the CO-02 go/no-go decision.
7. Launch cutover.
8. Validate and reconcile.
9. Finalize cutover only after acceptance.
10. Archive the application and source servers when hypercare closes.

## Global view

Global view is used when the migration spans multiple accounts. It requires an AWS Organizations management account or an MGN delegated administrator. It enables monitoring and actions across source servers, applications, and waves in multiple accounts.

This single-account laboratory documents the capability, but it is not a prerequisite. If enabled, record:

- Management account or delegated administrator.
- Linked member accounts.
- MGN initialized region for each account.
- Organizations permissions and trusted access.
- KMS key and access model when customer-managed encryption is used.

## Launch history

Every operation generates a Job. For CO-02, retain at minimum:

| Evidence | Fields |
|---|---|
| Test job | Job ID, type, initiated by, start, end, status, and servers |
| Test job log | Conversion events, test instance, errors, and timestamps |
| Cutover job | Job ID, cutover instance, status, and servers |
| Cutover job log | Steps, conversion server, EC2 instance IDs, and errors |
| Termination job | Terminated test resources and status |

A `Failed` Job or a `Pending` Job outside its threshold blocks the next step. The Cutover Manager links every Job ID to the CO-02 record.

## MGN connectors

The connector automates prerequisite checks, credential registration, and replication-agent installation. The dashboard shows the connector name, number of registered servers, and `Last seen` value.

Checklist:

- Connector deployed in a network that can reach the source servers.
- SSM hybrid activation and roles approved.
- Temporary credentials used; never store secrets in the repository.
- DNS resolution and ports verified.
- `Last seen` within the operating threshold.
- Command history reviewed with no unresolved failures.
- Server credentials registered through the authorized mechanism.
- Replication agent installed and validated.

For three servers, the agent can be installed directly; a connector is justified when it provides repeatable automation or as the portfolio grows. AWS documents up to 500 servers per connector and up to 50 connectors per account and region.

## Import and export

MGN can import and export source servers, applications, waves, and launch-template attributes through CSV from a local disk or S3.

The repository example is [`../data/mgn-import-wave-02.csv`](../data/mgn-import-wave-02.csv). Before importing it:

1. Replace region, FQDN, subnet, security group, and instance profile with sandbox-account values.
2. Confirm that `mgn:server:user-provided-id`, `mgn:app:name`, and `mgn:wave:name` do not collide with incorrect entities.
3. Run Import and review the import history row by row.
4. Export the resulting inventory.
5. Compare the export with the source file and `application-portfolio.csv`.

No real organization IDs, credentials, or addresses are included. Import does not support IPv6. AWS-managed import policies are broad; for production, analyze the actions used and reduce permissions with IAM Access Analyzer.

## Relationship to cutover CO-02

| Time | MGN view | Evidence | Decision |
|---|---|---|---|
| T-24 h | Source servers / Application | Healthy replication and test completed | Continue preparation |
| T-60 min | Wave / Global view | All components ready | Preliminary go/no-go |
| T-0 | Wave | Launch cutover initiated | Open the window |
| T+30 min | Launch history | Job completed without errors | Start final UAT |
| T+60 min | Source servers / Application | Metrics and reconciliation approved | Accept or roll back |
| Closure | Launch history / Wave | Finalize cutover and archive | Close CO-02 |

## Official references

- [AWS Transform MGN console](https://docs.aws.amazon.com/mgn/latest/ug/mgn-console.html)
- [Manage source servers](https://docs.aws.amazon.com/mgn/latest/ug/server-list.html)
- [Group applications in waves](https://docs.aws.amazon.com/mgn/latest/ug/waves.html)
- [Global view](https://docs.aws.amazon.com/mgn/latest/ug/global-view-main.html)
- [Launch history](https://docs.aws.amazon.com/mgn/latest/ug/jobs.html)
- [MGN connectors](https://docs.aws.amazon.com/mgn/latest/ug/mgn-connector-main.html)
- [Import and export](https://docs.aws.amazon.com/mgn/latest/ug/import-export.html)
