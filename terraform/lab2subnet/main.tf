# Lookup existing VPC by name tag
data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.this.id
  cidr_block        = var.cidr_block_private
  availability_zone = "us-east-1a"  # Specify AZ
  tags = {
    Name = var.subnet_name_private
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = data.aws_vpc.this.id
  cidr_block              = var.cidr_block_public
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true  # Enable public IPs
  tags = {
    Name = var.subnet_name_public
  }
}
