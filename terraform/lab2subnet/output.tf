output "vpc_id" {
  description = "The ID of the selected VPC"
  value       = data.aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the selected VPC"
  value       = data.aws_vpc.this.cidr_block
}

output "subnet_private_id" {
  description = "ID of the created private subnet"
  value       = aws_subnet_private.this.id
}

output "subnet_public_id" {

  description = "ID of the pubblic subnet created"
  value       = aws_subnet_public.this.id
}