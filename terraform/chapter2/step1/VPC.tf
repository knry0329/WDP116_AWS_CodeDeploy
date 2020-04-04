# Variable for CIDR
variable "cidr" {
  default = {
    vpc    = "172.16.0.0/16"
    subnet = ["172.16.0.0/24", "172.16.100.0/24"]
  }
}

# VPC
resource "aws_vpc" "wdb116" {
  cidr_block = var.cidr.vpc
  tags = {
    Name = "wdb116"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "wdb116" {
  vpc_id = aws_vpc.wdb116.id
  tags = {
    Name = "wdb116"
  }
}

# Default Route Table
resource "aws_default_route_table" "wdb116" {
  default_route_table_id = aws_vpc.wdb116.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wdb116.id
  }
  tags = {
    Name = "wdb116"
  }
}

# Get AZ Data
data "aws_availability_zones" "available" {
  state = "available"
}

# Subnet
resource "aws_subnet" "wdb116" {
  count                   = 2
  vpc_id                  = aws_vpc.wdb116.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.cidr.subnet[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "wdb116"
  }
}

# Output
output "vpc_id" {
  value = aws_internet_gateway.wdb116.vpc_id
}

output "subnet_ids" {
  value = [aws_subnet.wdb116.0.id,aws_subnet.wdb116.1.id]
}
