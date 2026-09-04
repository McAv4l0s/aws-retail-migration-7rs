data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "migration" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_subnet" "receptor" {
  vpc_id                  = aws_vpc.migration.id
  cidr_block              = var.receptor_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name_prefix}-receptor"
    Tier = "migration-receptor"
  }
}

resource "aws_subnet" "transit" {
  vpc_id                  = aws_vpc.migration.id
  cidr_block              = var.transit_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name_prefix}-transit"
    Tier = "transit"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.migration.id
  cidr_block              = var.private_a_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name_prefix}-private-a"
    Tier = "private"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.migration.id
  cidr_block              = var.private_b_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name_prefix}-private-b"
    Tier = "private"
  }
}
