provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "tf_backend_ec2" {
  instance_type = "t2.micro"
  ami = "ami-053b0d53c279acc90" 
  subnet_id = "subnet-019ea91ed9b5252e7" 
}

resource "aws_s3_bucket" "s3_backend" {
  bucket = "backend-s3-12345"
}

resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.s3_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_owernship" {
  bucket = aws_s3_bucket.s3_backend.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_dynamodb_table" "tf-locking" {
  name           = "tf_locking"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}