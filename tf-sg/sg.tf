provider "aws" {
  region = var.region_name
}

#Create security group with firewall rules
resource "aws_security_group" "SG1_SSH_HTTPS" {
  name        = "SG1_SSH_HTTPS"
  description = "security group for allowing SSH traffic to EC2 instances"
  vpc_id = var.vpc_id

 ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from Ec
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = "SG1_SSH_HTTPS"
  }
}
resource "aws_security_group" "SG2_SSH_HTTPS" {
  name        = "SG2_SSH_HTTPS"
  description = "security group for allowing SSH traffic to EC2 instances"
  vpc_id = var.vpc_id

 ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from Ec
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = "SG2_SSH_HTTPS"
  }

}


