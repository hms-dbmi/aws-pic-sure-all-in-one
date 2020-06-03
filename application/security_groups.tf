resource "aws_security_group" "inbound-from-public-internet" {
  name = "allow_inbound_from_public_internet_to_httpd"
  description = "Allow inbound traffic from public internet to httpd servers"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Owner       = "Avillach_Lab"
    Environment = "development"
    Name        = "PIC-SURE All-in-one - inbound-from-public-internet Security Group - ${var.environment_name}"
  }
}

resource "aws_security_group" "inbound-ssh-from-LMA" {
  name = "allow_inbound_ssh_from_lma"
  description = "Allow inbound traffic from LMA on port 22"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "172.25.255.73/32"
    ]
  }

  tags = {
    Owner       = "Avillach_Lab"
    Environment = "development"
    Name        = "PIC-SURE All-in-one - inbound-ssh-from-LMA - ${var.environment_name}"
  }
}

resource "aws_security_group" "outbound-to-internet" {
  name = "allow_outbound_to_public_internet_${var.stack_githash}"
  description = "Allow outbound traffic to public internet"
  vpc_id = var.target-vpc
  
  egress {
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Owner       = "Avillach_Lab"
    Environment = "development"
    Name        = "PIC-SURE All-in-one - outbound-to-internet Security Group - ${var.environment_name}"
  }
}
