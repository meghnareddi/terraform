resource "aws_s3_bucket" "mr_res1" {
  bucket = var.bucket_name

  tags = {
    Name        = var.object_key
    Environment = var.environment
  }
}