provider "aws" {
    region = var.region_name
  
}

resource "aws_s3_bucket" "s3-example" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.s3-example.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_owernship" {
  bucket = aws_s3_bucket.s3-example.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
