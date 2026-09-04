data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "migration_network" {
  dashboard_name = "${local.name_prefix}-migration-network"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 2
        properties = {
          markdown = "# ${local.name_prefix} migration network\nPrivate egress is expected to traverse the Transit Gateway and an external on-premises attachment."
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 2
        width  = 12
        height = 6
        properties = {
          title   = "VPC flow decisions"
          region  = data.aws_region.current.name
          view    = "timeSeries"
          stacked = false
          metrics = [
            [local.cloudwatch_namespace, "AcceptedFlows"],
            [".", "RejectedFlows"],
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 2
        width  = 12
        height = 6
        properties = {
          title  = "Unexpected management traffic"
          region = data.aws_region.current.name
          view   = "timeSeries"
          metrics = [
            [local.cloudwatch_namespace, "SshAttempts"],
            [".", "RdpAttempts"],
            [".", "IcmpFlows"],
          ]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 8
        width  = 24
        height = 6
        properties = {
          title  = "Transit Gateway blackhole drops"
          region = data.aws_region.current.name
          view   = "timeSeries"
          metrics = [
            ["AWS/TransitGateway", "BytesDropCountBlackhole", "TransitGateway", aws_ec2_transit_gateway.hub.id],
          ]
        }
      },
    ]
  })
}
