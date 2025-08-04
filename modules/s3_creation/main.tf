resource "aws_s3_bucket" "mr_res1" {
  bucket = "${var.bucket_name}-${random_integer.suffix.result}"

  tags = {
    Name        = var.object_key
    Environment = var.environment
  }
}


resource "random_integer" "suffix"{
  min = 1
  max = 1000
}