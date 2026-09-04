# Terraform Migration Network Foundation

This implementation extends the existing `10.40.0.0/16` VPC without changing its address space. It adds the receptor, transit, routing, security, observability, and alerting layers required by the migration design.

## Network map

| Subnet | CIDR | Availability zone | Role |
|---|---|---|---|
| `receptor` | `10.40.0.0/24` | First available AZ | Static migration receptor |
| `transit` | `10.40.1.0/24` | First available AZ | Transit Gateway VPC attachment |
| `private_a` | `10.40.10.0/24` | First available AZ | Migrated workload ENIs |
| `private_b` | `10.40.20.0/24` | Second available AZ | Migrated workload ENIs |

```text
Migrated workloads
        |
        v
Private route tables
        |
        v
Transit Gateway
        |
        v
Existing VPN or Direct Connect attachment
        |
        v
On-premises proxy / firewall
```

No NAT Gateway or Internet Gateway is created. There is no direct Internet route from any subnet.

## Declared components

| File | Terraform resource blocks | Purpose |
|---|---:|---|
| `vpc.tf` | 5 | VPC and four subnets |
| `routes.tf` | 14 | TGW, attachment, TGW route table, four VPC route tables, associations, and conditional on-premises route |
| `security_groups.tf` | 3 | Receptor, transit-appliance placeholder, and workload controls |
| `nacls.tf` | 3 | Receptor, transit, and workload subnet ACLs |
| `cloudwatch.tf` | 4 | Existing log-group design, IAM delivery role/policy, and VPC Flow Log |
| `cloudwatch_alarms.tf` | 13 | SNS, optional email subscription, five metric filters, and six alarms |
| `cloudwatch_dashboard.tf` | 1 | Network operations dashboard |

The configuration declares 43 resource blocks. With `alert_email` set and `on_premises_tgw_attachment_id = null`, 42 resources are instantiated. The 43rd resource is the TGW default route, created only after a real VPN or Direct Connect attachment is supplied.

Data sources for availability zones, AWS Region, and IAM policy documents are not included in the resource-block count.

## Routing safeguard

The route below is intentionally conditional:

```hcl
on_premises_tgw_attachment_id = null
```

When the value is `null`, Terraform does not create a TGW `0.0.0.0/0` route. Pointing that route at the VPC attachment itself would create an invalid circular design. After a VPN or Direct Connect TGW attachment exists, provide its `tgw-attach-*` identifier and review a new plan.

The four VPC route tables send RFC1918 destinations to the TGW. AWS retains the more-specific local VPC route for `10.40.0.0/16`.

## Security controls

- The receptor security group permits HTTPS (`443`) and MGN replication (`1500`) only from approved on-premises CIDRs.
- Workload egress is limited to RFC1918 address space; no `0.0.0.0/0` security-group rule is present.
- The transit security group is reserved for a future appliance ENI. Transit Gateway attachments do not consume security groups directly.
- Three stateless NACL layers explicitly permit required service and ephemeral ports.
- VPC Flow Logs deliver accepted and rejected traffic to `/portfolio/${var.project_name}/${var.environment}` with 30-day retention.

## Alarms and dashboard

| Alarm | Signal | Missing-data behavior |
|---|---|---|
| Rejected flows | VPC Flow Logs `REJECT` records | Not breaching |
| Accepted-flow volume | VPC Flow Logs `ACCEPT` records | Not breaching |
| SSH attempts | Destination TCP/22 | Not breaching |
| RDP attempts | Destination TCP/3389 | Not breaching |
| ICMP volume | Protocol 1 | Not breaching |
| TGW blackhole drops | `AWS/TransitGateway` dropped bytes | Breaching |

Setting `alert_email` creates an SNS email subscription. AWS keeps that subscription pending until the recipient confirms it. The dashboard displays accepted/rejected flows, unexpected management traffic, and TGW blackhole drops.

## Example variables

```hcl
# terraform.tfvars
project_name = "c2k-migration"
environment  = "dev"
aws_region   = "us-east-1"

vpc_cidr                = "10.40.0.0/16"
receptor_subnet_cidr    = "10.40.0.0/24"
transit_subnet_cidr     = "10.40.1.0/24"
private_a_subnet_cidr   = "10.40.10.0/24"
private_b_subnet_cidr   = "10.40.20.0/24"
on_premises_cidrs       = ["10.0.0.0/8"]

alert_email                       = null
on_premises_tgw_attachment_id     = null
```

Do not commit a real email address, credentials, account identifiers, or attachment identifiers to this public repository.

## Validation and deployment

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
terraform plan -out=c2kmig.tfplan
```

Review the complete plan before applying it:

```bash
terraform apply c2kmig.tfplan
```

If the original VPC has already been applied with `10.40.0.0/16`, retaining that CIDR avoids the forced VPC replacement associated with changing it to `10.230.0.0/22`. Always confirm the plan in the actual state backend.

## Production limitations

- The current TGW VPC attachment uses one transit subnet to preserve the agreed four-subnet design. A production high-availability design should add a transit subnet in a second AZ.
- The external VPN or Direct Connect attachment is not created by this project.
- DNS forwarding, proxy policy, firewall rules, and on-premises return routes must be validated end to end.
- Transit Gateway hourly/data-processing charges, CloudWatch Logs ingestion, alarms, dashboards, and SNS can incur cost.
- NACL and security-group ports must be reconciled with the final MGN and application dependency inventory before production.
