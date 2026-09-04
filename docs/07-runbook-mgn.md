# AWS Transform MGN Rehost Runbook

## Scope

This runbook applies to the auxiliary ERP classified as **Rehost**. MGN replicates servers; database migration, modernization, and relocation require different patterns.

## Preparation

- Confirm operating system, disks, space, network, and compatibility.
- Approve staging-area ports, endpoints, permissions, and encryption.
- Define replication, launch, and post-launch templates.
- Record owner, wave, tags, target instance, and licensing.
- Take an independent backup and verify restoration.

## Test

1. Install the authorized agent on the source.
2. Wait for initial synchronization and confirm acceptable lag and backlog.
3. Launch a test instance in an isolated network.
4. Apply post-launch actions and hardening.
5. Run smoke, integration, performance, security, and UAT tests.
6. Remediate findings and repeat until approved.

## Cutover

**CO-02 window:** May 22, 2026, 22:00–May 23, 02:00, `America/Mexico_City` time zone.

1. Start the freeze and command bridge.
2. Confirm the backup, healthy replication, and absence of lag.
3. Stop services that generate writes.
4. Launch the cutover instance.
5. Validate the system, integrations, monitoring, and reconciliation.
6. Shift traffic and DNS according to the approved TTL.
7. Observe during the stabilization window.
8. Finalize cutover only after acceptance.

Go/no-go criteria and the rollback time limit are defined in [`10-plan-de-cutover.md`](10-plan-de-cutover.md).

Complete operations for source servers, applications, waves, launch history, connectors, and import/export are documented in [`11-operacion-aws-transform-mgn.md`](11-operacion-aws-transform-mgn.md).

## Rollback

Rollback is performed before finalizing MGN: stop writes at the target, restore routing, start the source, validate integrity, and document differences. Reconciliation detail depends on transactions accepted during the window.
