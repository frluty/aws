output "vpc_id" {
  description = "The ID of the selected VPC"
  value       = data.aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the selected VPC"
  value       = data.aws_vpc.this.cidr_block
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = aws_subnet.this.id
}
