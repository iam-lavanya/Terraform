provider "aws" {
  region = var.primary_region
}

#Create EC2 instance for testing purpose
resource "aws_instance" "ec2" {
  subnet_id = var.subnet_id
  ami     = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  vpc_security_group_ids= [var.securitygrp_id]
  user_data = "${file("test.sh")}"
  tags= {
    Name = "Demo Instance"
  }
}  

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.EBS_ec2.id
  instance_id = aws_instance.ec2.id
}

resource "aws_ebs_volume" "EBS_ec2" {
  availability_zone = "var.availability_zone"
  size              = 1
    tags = {
    Name = "HelloEBS"
  }
}
