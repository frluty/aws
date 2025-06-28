# Lookup existing VPC by name tag
data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Create a private subnet inside the VPC
resource "aws_subnet_private" "this" {
  vpc_id            = data.aws_vpc.this.id
  cidr_block        = var.cidr_block_private
  tags = {
    Name = var.subnet_name_private
  }
}

resource "aws_subnet_public" "this"{
  vpc_id          = data.aws_vpc.this.id
  cidr_block      = var.cidr_block_public
  tags = {
      Name = var.subnet_name_public
  }
}