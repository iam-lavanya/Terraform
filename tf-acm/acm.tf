provider "aws" {
region = "us-east-1"
  
}
resource "aws_acm_certificate" "Packers_movers" {
  domain_name       = ""
  validation_method = "DNS" 

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}


