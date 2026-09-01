variable "aws_region" {
  description = "AWS region approved for the laboratory."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project identifier used for names and cost allocation."
  type        = string
  default     = "retail-migration-7rs"
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

