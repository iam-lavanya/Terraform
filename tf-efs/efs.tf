provider "aws" {
  region = var.region_name
  
}
resource "aws_efs_file_system" "efs_fs" {
  creation_token = "file-system"

  tags = {
    Name = "efs-fs"
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  file_system_id = aws_efs_file_system.efs_fs.id
  subnet_id      = aws_subnet.test_sub.id
}

resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "test_sub" {
  vpc_id            = aws_vpc.test_vpc.id
  availability_zone = var.availability_zone
  cidr_block        = "10.0.1.0/24"
}