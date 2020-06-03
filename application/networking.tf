resource "aws_vpc" "vpc" {
  cidr_block = "172.17.0.0/16"
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Owner       = "Avillach_Lab"
    Environment = "development"
    Name        = "PIC-SURE All-in-one VPC - ${var.environment_name}"
  }

}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  tags = {
    Owner       = "Avillach_Lab"
    Environment = "development"
    Name        = "PIC-SURE All-in-one No Access Security Group - ${var.environment_name}"
  }
}

resource "aws_internet_gateway" "inet-gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Owner       = "Avillach_Lab"
    Environment = "development"
    Name        = "PIC-SURE All-in-one Internet Gateway - ${var.environment_name}"
  }  
}

resource "aws_subnet" "subnet-us-east-1a" {
  availability_zone = "us-east-1a"
  cidr_block = "172.17.0.0/26"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Owner       = "Avillach_Lab"
    Environment = "development"
    Name        = "PIC-SURE All-in-one Public Subnet us-east-1a - ${var.environment_name}"
  }
}

resource "aws_subnet" "subnet-us-east-1b" {
  availability_zone = "us-east-1b"
  cidr_block = "172.17.0.64/26"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Owner       = "Avillach_Lab"
    Environment = "development"
    Name        = "PIC-SURE All-in-one Public Subnet us-east-1b - ${var.environment_name}"
  }
}


resource "aws_default_route_table" "route-table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inet-gw.id
  }
  tags = {
    Owner       = "Avillach_Lab"
    Environment = "development"
    Name        = "PIC-SURE All-in-one Route Table - ${var.environment_name}"
  }
}

resource "aws_route_table_association" "route-table-us-east-1a-association" {
  subnet_id = aws_subnet.subnet-us-east-1a.id
  route_table_id = aws_vpc.vpc.default_route_table_id
}
resource "aws_route_table_association" "route-table-us-east-1b-association" {
  subnet_id = aws_subnet.subnet-us-east-1b.id
  route_table_id = aws_vpc.vpc.default_route_table_id
}