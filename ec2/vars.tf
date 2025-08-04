variable "instance_count" {
  description = "number of instances"
  type    = number 
  default = 1
}

variable "ami_id" {
  description = "Amazon Machine Image ID"
  default     = "ami-08ca1d1e465fbfe0c" 
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "EC2 Key pair name"
}

variable "ec2_name" {
  default = "Meghna-EC2"
}


variable "region" {
  default = "us-east-2"
}

variable "environment"{
  default = "test"
}