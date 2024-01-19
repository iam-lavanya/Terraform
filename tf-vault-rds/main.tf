provider "aws" {
  region = var.region_name # Change this to your desired region
}
# The RDS instance resource requires an ARN. Look up the ARN of the KMS key.
data "aws_kms_key" "kms_key" {
  key_id = var.kms # KMS key
}

provider "vault" {
  address = "<>:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "<>"
      secret_id = "<>"
    }
  }
}

resource "aws_db_instance" "default" {
  kms_key_id            = data.aws_kms_key.kms.arn
  identifier            = "psk1"
  allocated_storage    = 20
  storage_type          = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.33"
  instance_class        = "db.t3.micro"
  db_name               = "psk1db"
  username              = "psk1"
  password              = "pskpskpsk"
  storage_encrypted = true

#   parameter_group_name = "default:mysql-8-0"
#   custom_iam_instance_profile = "AWSRDSCustomSQLServerInstanceRole"
  
  vpc_security_group_ids = [var.vpc_security_group_ids]


  multi_az              = false
  availability_zone     = "var.availability_zone"
}


resource "aws_db_subnet_group" "subnet-group1" {
  name       = "subnet-group1"
  subnet_ids = ["subnet-0e197f08b5b755257", "subnet-046277c041194b849","subnet-0684def2973a370da", "subnet-0c91eb495e92fc850","subnet-04b7d58a379c261f2"] 
}

