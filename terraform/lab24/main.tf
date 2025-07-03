# Lookup existing VPC
data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Create PUBLIC SUBNET
resource "aws_subnet" "public" {
  vpc_id                  = data.aws_vpc.this.id
  cidr_block              = var.cidr_block
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

# Create INTERNET GATEWAY
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

# SECURITY GROUP for SSH
resource "aws_security_group" "pod1_ssh_sg" {
  name        = "pod1-ssh-security-group"
  description = "Security group for SSH access"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description = "SSH from anywhere IPv4"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound IPv4 traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pod1-ssh-security-group"
  }
}

# KEY PAIR
resource "tls_private_key" "pod1_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  content        = tls_private_key.pod1_vm_key.private_key_pem
  filename       = var.private_key_path
  file_permission = "0600"
}

resource "aws_key_pair" "pod1_vm_key" {
  key_name   = var.key_name
  public_key = tls_private_key.pod1_vm_key.public_key_openssh
}

# AMI Ubuntu 20.04 spécifique
data "aws_ami" "ubuntu_focal" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}


# EC2 INSTANCE
resource "aws_instance" "pod1_vm" {
  ami                         = data.aws_ami.ubuntu_focal.id
  instance_type               = "t2.nano"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.pod1_ssh_sg.id]
  key_name                    = aws_key_pair.pod1_vm_key.key_name
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "pod1-vm"
  }
}
