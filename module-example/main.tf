provider "aws" {
    region = "us-east-1"
  
}

module "s3_module" {
    source = "C:/Users/lchekuri/OneDrive - DXC Production/Documents/AWS/Terraform Examples/terraform/module-example/modules/tf-ec2"
  
}
