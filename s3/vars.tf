variable "bucket_name" {
  type    = string
  default = "my-demo-test-bucket2"
}

variable "object_key" {
  type    = string
  default = "new_object_key"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-east-2"
}
