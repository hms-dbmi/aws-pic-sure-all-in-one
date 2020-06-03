
data "template_file" "user_data" {
  template = file("scripts/user_data.sh")
  vars = {
    environment_name = var.environment_name
  }
}

data "template_cloudinit_config" "user-data" {
  gzip          = true
  base64_encode = true

  # user_data
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.user_data.rendered
  }

}

resource "aws_instance" "hpds-ec2" {
  depends_on = [
    local_file.wildfly-standalone-xml-file
  ]

  ami = var.ami-id
  instance_type = "m5.2xlarge"

  associate_public_ip_address = false

  subnet_id = aws_subnet.subnet-us-east-1b.id

  user_data = data.template_cloudinit_config.hpds-user-data.rendered

  vpc_security_group_ids = [
    aws_security_group.outbound-to-internet.id,
    aws_security_group.inbound-ssh-from-LMA.id
  ]
  root_block_device {
    delete_on_termination = true
    encrypted = true
    volume_size = 500
  }

  tags = {
    Owner       = "Avillach_Lab"
    Environment = "development"
    Name        = "PIC-SURE All-in-one - ${var.environment_name}"
    WHY         = "PIC-SURE All-in-one - ${var.environment_name}"
  }

}

resource "aws_route53_record" "hpds" {
  zone_id = var.internal-dns-zone-id
  name    = "hpds.${var.target-stack}"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.hpds-ec2.private_ip]
}
