

/*import {
  to = aws_secretsmanager_secret.db_example
  id = "arn:aws:secretsmanager:us-east-1:796550649590:secret:prod/db/db_secret-bPHmYA"
}*/

/*resource "aws_secretsmanager_secret" "db_example" {
  name = "prod/db/db_secret"
}*/

data "aws_secretsmanager_secret" "db_secret" {
  name = "db_secret"
}
data "aws_secretsmanager_secret_version" "secret_credentials" {
 secret_id = data.aws_secretsmanager_secret.db_secret.id
}


provider "aws" {
  region = var.region_name # Change this to your desired region
}
# The RDS instance resource requires an ARN. Look up the ARN of the KMS key.
data "aws_kms_key" "kms_key" {
  key_id = var.kms# KMS key
}

resource "aws_db_instance" "default" {
  kms_key_id            = data.aws_kms_key.kms_key.arn
  identifier            = "psk1"
  allocated_storage    = 20
  storage_type          = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.33"
  instance_class        = "db.t3.micro"
  db_name               = "psk1db"
  username              = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials.secret_string)["db_username"]
  password              = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials.secret_string)["db_password"]
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


