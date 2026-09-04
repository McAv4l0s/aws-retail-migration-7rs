resource "aws_ec2_transit_gateway" "hub" {
  description                     = "Hybrid routing hub for ${local.name_prefix}"
  amazon_side_asn                 = var.transit_gateway_asn
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "${local.name_prefix}-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "migration" {
  subnet_ids                                      = [aws_subnet.transit.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.hub.id
  vpc_id                                          = aws_vpc.migration.id
  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = "${local.name_prefix}-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table" "migration" {
  transit_gateway_id = aws_ec2_transit_gateway.hub.id

  tags = {
    Name = "${local.name_prefix}-tgw-rt"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "migration" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.migration.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.migration.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "migration" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.migration.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.migration.id
}

resource "aws_ec2_transit_gateway_route" "default_to_on_premises" {
  count = var.on_premises_tgw_attachment_id == null ? 0 : 1

  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = var.on_premises_tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.migration.id
}

resource "aws_route_table" "receptor" {
  vpc_id = aws_vpc.migration.id

  dynamic "route" {
    for_each = toset(local.rfc1918_cidrs)
    content {
      cidr_block         = route.value
      transit_gateway_id = aws_ec2_transit_gateway.hub.id
    }
  }

  tags = { Name = "${local.name_prefix}-receptor-rt" }
}

resource "aws_route_table" "transit" {
  vpc_id = aws_vpc.migration.id

  dynamic "route" {
    for_each = toset(local.rfc1918_cidrs)
    content {
      cidr_block         = route.value
      transit_gateway_id = aws_ec2_transit_gateway.hub.id
    }
  }

  tags = { Name = "${local.name_prefix}-transit-rt" }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.migration.id

  dynamic "route" {
    for_each = toset(local.rfc1918_cidrs)
    content {
      cidr_block         = route.value
      transit_gateway_id = aws_ec2_transit_gateway.hub.id
    }
  }

  tags = { Name = "${local.name_prefix}-private-a-rt" }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.migration.id

  dynamic "route" {
    for_each = toset(local.rfc1918_cidrs)
    content {
      cidr_block         = route.value
      transit_gateway_id = aws_ec2_transit_gateway.hub.id
    }
  }

  tags = { Name = "${local.name_prefix}-private-b-rt" }
}

resource "aws_route_table_association" "receptor" {
  subnet_id      = aws_subnet.receptor.id
  route_table_id = aws_route_table.receptor.id
}

resource "aws_route_table_association" "transit" {
  subnet_id      = aws_subnet.transit.id
  route_table_id = aws_route_table.transit.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}
