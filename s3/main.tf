provider "aws" {
  region = var.region
}

module "create_s3" {
  source      = "../modules/s3_creation"
  bucket_name = var.bucket_name
  object_key  = var.object_key
  environment = var.environment
}
