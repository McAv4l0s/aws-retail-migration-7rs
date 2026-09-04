locals {
  name_prefix          = "${var.project_name}-${var.environment}"
  cloudwatch_namespace = "Portfolio/MigrationNetwork"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Portfolio   = "aws-migration"
  }

  rfc1918_cidrs = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]

  rfc1918_rule_map = {
    for index, cidr in local.rfc1918_cidrs : tostring(index) => {
      cidr   = cidr
      offset = index
    }
  }

  on_premises_rule_map = {
    for index, cidr in var.on_premises_cidrs : tostring(index) => {
      cidr   = cidr
      offset = index
    }
  }

  subnet_ids = {
    receptor  = aws_subnet.receptor.id
    transit   = aws_subnet.transit.id
    private_a = aws_subnet.private_a.id
    private_b = aws_subnet.private_b.id
  }
}
