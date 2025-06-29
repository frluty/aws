variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS CLI profile"
  type        = string
}

variable "vpc_name" {
  description = "Name tag of existing VPC"
  type        = string
}

variable "subnet_name" {
  description = "Name for new public subnet"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for new subnet"
  type        = string
}

variable "internet_gateway_name" {
  description = "Name for internet gateway"
  type        = string
}

variable "route_table_name" {
  description = "Name for route table"
  type        = string
}

variable "cidr_block_route_table" {
  description = "CIDR block for default route"
  type        = string
  default     = "0.0.0.0/0"
}
