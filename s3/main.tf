terraform {
  backend "s3" {
    bucket = "mr-terraform-state-bucket"
    key    = "envs/dev/s3/terraform.tfstate"
    region = "us-east-2"
  }
}


provider "aws" {
  region = var.region
}

module "create_s3" {
  source      = "../modules/s3_creation"
  bucket_name = var.bucket_name
  object_key  = var.object_key
  environment = var.environment
}
