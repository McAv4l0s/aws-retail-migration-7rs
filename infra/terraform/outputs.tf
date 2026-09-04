output "vpc_id" {
  description = "Migration VPC identifier."
  value       = aws_vpc.migration.id
}

output "subnet_ids" {
  description = "Subnet identifiers by migration role."
  value       = local.subnet_ids
}

output "transit_gateway_id" {
  description = "Transit Gateway identifier."
  value       = aws_ec2_transit_gateway.hub.id
}

output "transit_gateway_vpc_attachment_id" {
  description = "Migration VPC attachment identifier."
  value       = aws_ec2_transit_gateway_vpc_attachment.migration.id
}

output "transit_gateway_route_table_id" {
  description = "Transit Gateway route table identifier."
  value       = aws_ec2_transit_gateway_route_table.migration.id
}

output "vpc_route_table_ids" {
  description = "VPC route table identifiers by subnet role."
  value = {
    receptor  = aws_route_table.receptor.id
    transit   = aws_route_table.transit.id
    private_a = aws_route_table.private_a.id
    private_b = aws_route_table.private_b.id
  }
}

output "security_group_ids" {
  description = "Security group identifiers by network layer."
  value = {
    receptor = aws_security_group.receptor.id
    transit  = aws_security_group.transit.id
    workload = aws_security_group.migration_workload.id
  }
}

output "network_acl_ids" {
  description = "Network ACL identifiers by network layer."
  value = {
    receptor  = aws_network_acl.receptor.id
    transit   = aws_network_acl.transit.id
    workloads = aws_network_acl.workloads.id
  }
}

output "flow_log_id" {
  description = "VPC Flow Log identifier."
  value       = aws_flow_log.migration.id
}

output "flow_log_group_name" {
  description = "CloudWatch Logs destination for VPC Flow Logs."
  value       = aws_cloudwatch_log_group.migration.name
}

output "network_alerts_topic_arn" {
  description = "SNS topic ARN for network alarms."
  value       = aws_sns_topic.network_alerts.arn
}

output "network_dashboard_name" {
  description = "CloudWatch dashboard name."
  value       = aws_cloudwatch_dashboard.migration_network.dashboard_name
}

output "on_premises_default_route_enabled" {
  description = "Whether the TGW default route points to an existing on-premises attachment."
  value       = var.on_premises_tgw_attachment_id != null
}
