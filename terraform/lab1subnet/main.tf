# Lookup existing VPC by name tag
data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Create a subnet inside the VPC
resource "aws_subnet" "this" {
  vpc_id            = data.aws_vpc.this.id
  cidr_block        = var.cidr_block
  availability_zone = "${var.region}a"  # optionnel mais précis

  tags = {
    Name = var.subnet_name
  }
}
