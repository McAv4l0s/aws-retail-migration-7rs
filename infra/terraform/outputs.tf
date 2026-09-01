output "vpc_id" {
  description = "Laboratory VPC identifier."
  value       = aws_vpc.migration.id
}

output "private_subnet_ids" {
  description = "Private subnet identifiers used by migrated workloads."
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

