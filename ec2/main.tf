/*
terraform {
  backend "s3" {
    bucket = "mr-terraform-state-bucket"
    key    = "envs/dev/ec2/terraform.tfstate"
    region = "us-west-2"
  }
}
*/

provider "aws" {
  region = var.region
}

module "create_ec2" {
  source      = "../modules/ec2_creation"
  count = var.instance_count
  instance_type = var.instance_type
  ami_id  = var.ami_id
  key_name = var.key_name
  ec2_name = var.ec2_name
  environment = var.environment
}