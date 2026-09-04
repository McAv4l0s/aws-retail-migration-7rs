resource "aws_network_acl" "receptor" {
  vpc_id     = aws_vpc.migration.id
  subnet_ids = [aws_subnet.receptor.id]

  dynamic "ingress" {
    for_each = local.on_premises_rule_map
    content {
      protocol   = "tcp"
      rule_no    = 100 + ingress.value.offset
      action     = "allow"
      cidr_block = ingress.value.cidr
      from_port  = 443
      to_port    = 443
    }
  }

  dynamic "ingress" {
    for_each = local.on_premises_rule_map
    content {
      protocol   = "tcp"
      rule_no    = 200 + ingress.value.offset
      action     = "allow"
      cidr_block = ingress.value.cidr
      from_port  = 1500
      to_port    = 1500
    }
  }

  dynamic "ingress" {
    for_each = local.on_premises_rule_map
    content {
      protocol   = "tcp"
      rule_no    = 300 + ingress.value.offset
      action     = "allow"
      cidr_block = ingress.value.cidr
      from_port  = 1024
      to_port    = 65535
    }
  }

  dynamic "egress" {
    for_each = local.rfc1918_rule_map
    content {
      protocol   = "tcp"
      rule_no    = 100 + egress.value.offset
      action     = "allow"
      cidr_block = egress.value.cidr
      from_port  = 443
      to_port    = 443
    }
  }

  dynamic "egress" {
    for_each = local.rfc1918_rule_map
    content {
      protocol   = "tcp"
      rule_no    = 200 + egress.value.offset
      action     = "allow"
      cidr_block = egress.value.cidr
      from_port  = 1500
      to_port    = 1500
    }
  }

  dynamic "egress" {
    for_each = local.rfc1918_rule_map
    content {
      protocol   = "tcp"
      rule_no    = 300 + egress.value.offset
      action     = "allow"
      cidr_block = egress.value.cidr
      from_port  = 1024
      to_port    = 65535
    }
  }

  tags = { Name = "${local.name_prefix}-receptor-nacl" }
}

resource "aws_network_acl" "transit" {
  vpc_id     = aws_vpc.migration.id
  subnet_ids = [aws_subnet.transit.id]

  dynamic "ingress" {
    for_each = local.rfc1918_rule_map
    content {
      protocol   = "-1"
      rule_no    = 100 + ingress.value.offset
      action     = "allow"
      cidr_block = ingress.value.cidr
      from_port  = 0
      to_port    = 0
    }
  }

  dynamic "egress" {
    for_each = local.rfc1918_rule_map
    content {
      protocol   = "-1"
      rule_no    = 100 + egress.value.offset
      action     = "allow"
      cidr_block = egress.value.cidr
      from_port  = 0
      to_port    = 0
    }
  }

  tags = { Name = "${local.name_prefix}-transit-nacl" }
}

resource "aws_network_acl" "workloads" {
  vpc_id     = aws_vpc.migration.id
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  dynamic "ingress" {
    for_each = local.rfc1918_rule_map
    content {
      protocol   = "tcp"
      rule_no    = 100 + ingress.value.offset
      action     = "allow"
      cidr_block = ingress.value.cidr
      from_port  = 443
      to_port    = 443
    }
  }

  dynamic "ingress" {
    for_each = local.rfc1918_rule_map
    content {
      protocol   = "tcp"
      rule_no    = 200 + ingress.value.offset
      action     = "allow"
      cidr_block = ingress.value.cidr
      from_port  = 1024
      to_port    = 65535
    }
  }

  dynamic "egress" {
    for_each = local.rfc1918_rule_map
    content {
      protocol   = "tcp"
      rule_no    = 100 + egress.value.offset
      action     = "allow"
      cidr_block = egress.value.cidr
      from_port  = 443
      to_port    = 443
    }
  }

  dynamic "egress" {
    for_each = local.rfc1918_rule_map
    content {
      protocol   = "tcp"
      rule_no    = 200 + egress.value.offset
      action     = "allow"
      cidr_block = egress.value.cidr
      from_port  = 1024
      to_port    = 65535
    }
  }

  tags = { Name = "${local.name_prefix}-workloads-nacl" }
}
