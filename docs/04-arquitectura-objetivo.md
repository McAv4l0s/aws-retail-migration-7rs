# Target Architecture

## Principles

- Separate accounts by environment and function.
- Federated human access with no permanent users for daily operations.
- Encryption, logging, and tagging enabled at the platform level.
- High availability proportional to criticality.
- Prefer managed services when they reduce operational burden.
- Use asynchronous interfaces to absorb peaks and transient failures.

## Target flow

```mermaid
flowchart TB
    subgraph Edge
      CF[CloudFront]
      WA[AWS WAF]
    end
    subgraph Application
      ALB[Application Load Balancer]
      APP[Checkout services]
      EVT[EventBridge / SQS]
      WORK[Order workers]
    end
    subgraph Data
      RDS[(Amazon RDS Multi-AZ)]
      S3[(Amazon S3)]
    end
    subgraph Migrated
      EC2[ERP on EC2]
      MGN[MGN staging]
    end
    CF --> WA --> ALB --> APP
    APP --> RDS
    APP --> EVT --> WORK --> EC2
    APP --> S3
    MGN -. replication/cutover .-> EC2
```

## Cross-cutting controls

CloudTrail and centralized logs, metrics and alarms, configuration detection, secrets management, backups with restore testing, mandatory tagging, and account-level budgets. Exact services are confirmed from requirements, region, and cost; the diagram does not replace detailed design.
