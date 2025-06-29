
# Lookup existing VPC
data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Create PUBLIC SUBNET (since it doesn't exist)
resource "aws_subnet" "public" {
  vpc_id                  = data.aws_vpc.this.id
  cidr_block              = var.cidr_block
  availability_zone       = "${var.region}a"  # Uses first AZ in region
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

# Create INTERNET GATEWAY (since it doesn't exist)
resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_vpc.this.id
  tags = {
    Name = var.internet_gateway_name
  }
}

# Create ROUTE TABLE
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.this.id

  route {
    cidr_block = var.cidr_block_route_table
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.route_table_name
  }
}

# Associate route table with new subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
