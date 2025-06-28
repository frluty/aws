output "vpc_id" {
  description = "The ID of the selected VPC"
  value       = data.aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the selected VPC"
  value       = data.aws_vpc.this.cidr_block
}

output "aws_subnet_private" {
  description = "ID of the created private subnet"
  value       = aws_subnet.private.id
}

output "aws_subnet_public" {

  description = "ID of the pubblic subnet created"
  value       = aws_subnet.public.id
}