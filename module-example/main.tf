provider "aws" {
    region = var.region_name
  
}

module "s3_module" {
    source = "./modules/module/tf-s3"
  
}
