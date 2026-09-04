variable "aws_region" {
  description = "AWS region approved for the laboratory."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project identifier used for names and cost allocation."
  type        = string
  default     = "c2k-migration"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test, or prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block retained from the existing migration VPC."
  type        = string
  default     = "10.40.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "receptor_subnet_cidr" {
  description = "CIDR for the static migration receptor subnet."
  type        = string
  default     = "10.40.0.0/24"
}

variable "transit_subnet_cidr" {
  description = "CIDR for the Transit Gateway attachment subnet."
  type        = string
  default     = "10.40.1.0/24"
}

variable "private_a_subnet_cidr" {
  description = "CIDR for migrated workloads in the first availability zone."
  type        = string
  default     = "10.40.10.0/24"
}

variable "private_b_subnet_cidr" {
  description = "CIDR for migrated workloads in the second availability zone."
  type        = string
  default     = "10.40.20.0/24"
}

variable "on_premises_cidrs" {
  description = "Approved on-premises networks that reach AWS through the hybrid attachment."
  type        = list(string)
  default     = ["10.0.0.0/8"]

  validation {
    condition     = length(var.on_premises_cidrs) > 0 && alltrue([for cidr in var.on_premises_cidrs : can(cidrhost(cidr, 0))])
    error_message = "on_premises_cidrs must contain at least one valid IPv4 CIDR block."
  }
}

variable "on_premises_tgw_attachment_id" {
  description = "Existing VPN or Direct Connect Transit Gateway attachment ID. Leave null until the attachment exists; no default route is created otherwise."
  type        = string
  default     = null

  validation {
    condition     = var.on_premises_tgw_attachment_id == null || can(regex("^tgw-attach-[0-9a-f]+$", var.on_premises_tgw_attachment_id))
    error_message = "on_premises_tgw_attachment_id must be null or a valid tgw-attach identifier."
  }
}

variable "transit_gateway_asn" {
  description = "Private ASN assigned to the Transit Gateway."
  type        = number
  default     = 64512

  validation {
    condition     = var.transit_gateway_asn >= 64512 && var.transit_gateway_asn <= 65534
    error_message = "transit_gateway_asn must be between 64512 and 65534."
  }
}

variable "alert_email" {
  description = "Optional email endpoint for SNS network alerts. The subscription remains pending until the recipient confirms it."
  type        = string
  default     = null

  validation {
    condition     = var.alert_email == null || can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alert_email))
    error_message = "alert_email must be null or a valid email address."
  }
}

variable "rejected_flow_threshold" {
  description = "Rejected-flow count within five minutes that triggers an alarm."
  type        = number
  default     = 100
}

variable "accepted_flow_threshold" {
  description = "Accepted-flow count within five minutes that triggers a volume alarm."
  type        = number
  default     = 10000
}

variable "icmp_flow_threshold" {
  description = "ICMP-flow count within five minutes that triggers an alarm."
  type        = number
  default     = 100
}
