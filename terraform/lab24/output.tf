output "vpc_id" {
  description = "The ID of the selected VPC"
  value       = data.aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the selected VPC"
  value       = data.aws_vpc.this.cidr_block
}

output "aws_subnet_public" {
  description = "ID of the public subnet created"
  value       = aws_subnet.public.id
}

output "pod1_vm_public_ip" {
  value = aws_instance.pod1_vm.public_ip
}
