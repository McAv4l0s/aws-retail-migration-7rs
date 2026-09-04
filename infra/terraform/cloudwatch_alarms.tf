resource "aws_sns_topic" "network_alerts" {
  name = "${local.name_prefix}-network-alerts"

  tags = { Name = "${local.name_prefix}-network-alerts" }
}

resource "aws_sns_topic_subscription" "email" {
  count = var.alert_email == null ? 0 : 1

  topic_arn = aws_sns_topic.network_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_log_metric_filter" "rejected_flows" {
  name           = "${local.name_prefix}-rejected-flows"
  log_group_name = aws_cloudwatch_log_group.migration.name
  pattern        = "[version, account_id, interface_id, srcaddr, dstaddr, srcport, dstport, protocol, packets, bytes, start, end, action = \"REJECT\", log_status]"

  metric_transformation {
    name          = "RejectedFlows"
    namespace     = local.cloudwatch_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "accepted_flows" {
  name           = "${local.name_prefix}-accepted-flows"
  log_group_name = aws_cloudwatch_log_group.migration.name
  pattern        = "[version, account_id, interface_id, srcaddr, dstaddr, srcport, dstport, protocol, packets, bytes, start, end, action = \"ACCEPT\", log_status]"

  metric_transformation {
    name          = "AcceptedFlows"
    namespace     = local.cloudwatch_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "ssh_attempts" {
  name           = "${local.name_prefix}-ssh-attempts"
  log_group_name = aws_cloudwatch_log_group.migration.name
  pattern        = "[version, account_id, interface_id, srcaddr, dstaddr, srcport, dstport = \"22\", protocol = \"6\", packets, bytes, start, end, action, log_status]"

  metric_transformation {
    name          = "SshAttempts"
    namespace     = local.cloudwatch_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "rdp_attempts" {
  name           = "${local.name_prefix}-rdp-attempts"
  log_group_name = aws_cloudwatch_log_group.migration.name
  pattern        = "[version, account_id, interface_id, srcaddr, dstaddr, srcport, dstport = \"3389\", protocol = \"6\", packets, bytes, start, end, action, log_status]"

  metric_transformation {
    name          = "RdpAttempts"
    namespace     = local.cloudwatch_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "icmp_flows" {
  name           = "${local.name_prefix}-icmp-flows"
  log_group_name = aws_cloudwatch_log_group.migration.name
  pattern        = "[version, account_id, interface_id, srcaddr, dstaddr, srcport, dstport, protocol = \"1\", packets, bytes, start, end, action, log_status]"

  metric_transformation {
    name          = "IcmpFlows"
    namespace     = local.cloudwatch_namespace
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "rejected_flows" {
  alarm_name          = "${local.name_prefix}-rejected-flows"
  alarm_description   = "Rejected VPC flows exceeded the operating threshold."
  namespace           = local.cloudwatch_namespace
  metric_name         = aws_cloudwatch_log_metric_filter.rejected_flows.metric_transformation[0].name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Sum"
  threshold           = var.rejected_flow_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.network_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "accepted_flow_volume" {
  alarm_name          = "${local.name_prefix}-accepted-flow-volume"
  alarm_description   = "Accepted-flow volume exceeded the expected migration baseline."
  namespace           = local.cloudwatch_namespace
  metric_name         = aws_cloudwatch_log_metric_filter.accepted_flows.metric_transformation[0].name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  period              = 300
  statistic           = "Sum"
  threshold           = var.accepted_flow_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.network_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "ssh_attempts" {
  alarm_name          = "${local.name_prefix}-ssh-attempts"
  alarm_description   = "SSH traffic was observed even though SSH is not part of the approved migration path."
  namespace           = local.cloudwatch_namespace
  metric_name         = aws_cloudwatch_log_metric_filter.ssh_attempts.metric_transformation[0].name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.network_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "rdp_attempts" {
  alarm_name          = "${local.name_prefix}-rdp-attempts"
  alarm_description   = "RDP traffic was observed even though RDP is not part of the approved migration path."
  namespace           = local.cloudwatch_namespace
  metric_name         = aws_cloudwatch_log_metric_filter.rdp_attempts.metric_transformation[0].name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.network_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "icmp_flows" {
  alarm_name          = "${local.name_prefix}-icmp-flows"
  alarm_description   = "ICMP volume exceeded the diagnostic baseline."
  namespace           = local.cloudwatch_namespace
  metric_name         = aws_cloudwatch_log_metric_filter.icmp_flows.metric_transformation[0].name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Sum"
  threshold           = var.icmp_flow_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.network_alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "tgw_blackhole_drops" {
  alarm_name          = "${local.name_prefix}-tgw-blackhole-drops"
  alarm_description   = "The transit gateway dropped traffic because no valid route was available."
  namespace           = "AWS/TransitGateway"
  metric_name         = "BytesDropCountBlackhole"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  treat_missing_data  = "breaching"
  alarm_actions       = [aws_sns_topic.network_alerts.arn]

  dimensions = {
    TransitGateway = aws_ec2_transit_gateway.hub.id
  }
}
