resource "aws_security_group" "receptor" {
  name        = "${local.name_prefix}-receptor-sg"
  description = "Migration receptor traffic from approved on-premises networks"
  vpc_id      = aws_vpc.migration.id

  ingress {
    description = "HTTPS control traffic from on-premises"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.on_premises_cidrs
  }

  ingress {
    description = "MGN replication data from on-premises"
    from_port   = 1500
    to_port     = 1500
    protocol    = "tcp"
    cidr_blocks = var.on_premises_cidrs
  }

  egress {
    description = "Private network egress through hybrid routing"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.rfc1918_cidrs
  }

  tags = { Name = "${local.name_prefix}-receptor-sg" }
}

resource "aws_security_group" "transit" {
  name        = "${local.name_prefix}-transit-sg"
  description = "Reserved for a future transit appliance ENI; TGW attachments do not use security groups"
  vpc_id      = aws_vpc.migration.id

  ingress {
    description = "Private traffic to a future transit appliance"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.rfc1918_cidrs
  }

  egress {
    description = "Private traffic from a future transit appliance"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.rfc1918_cidrs
  }

  tags = { Name = "${local.name_prefix}-transit-sg" }
}

resource "aws_security_group" "migration_workload" {
  name        = "${local.name_prefix}-workload-sg"
  description = "Private application traffic for migrated workloads"
  vpc_id      = aws_vpc.migration.id

  ingress {
    description = "HTTPS from private networks"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.rfc1918_cidrs
  }

  egress {
    description = "Private network egress through TGW"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.rfc1918_cidrs
  }

  tags = { Name = "${local.name_prefix}-workload-sg" }
}
