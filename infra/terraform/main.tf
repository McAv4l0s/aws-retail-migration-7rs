locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Portfolio   = "aws-migration"
  }
}

resource "aws_vpc" "migration" {
  cidr_block           = "10.40.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.migration.id
  cidr_block        = "10.40.10.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.project_name}-${var.environment}-private-a"
    Tier = "private"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.migration.id
  cidr_block        = "10.40.20.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.project_name}-${var.environment}-private-b"
    Tier = "private"
  }
}

resource "aws_cloudwatch_log_group" "migration" {
  name              = "/portfolio/${var.project_name}/${var.environment}"
  retention_in_days = 30
}

