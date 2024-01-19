terraform {
  backend "s3" {
    bucket         = "backend-s3-12345" # change this
    key            = "tf-backend/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tf_locking"
  }
}