variable "bucket_name" {
  type = string
  description = "Name of the S3 bucket"
}

variable "object_key" {
  type = string
  description = "Key for tagging or object (optional)"
}

variable "environment" {
  type = string
  description = "Deployment environment"
}