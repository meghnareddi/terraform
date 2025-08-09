variable "region" {
  default = "us-east-2"
}

variable "kubernetes_version" {
  default = "1.29"
}

variable "cluster_name" {
  description = "EKS cluster name"
}

variable "vpc_id" {
  description = "VPC ID where EKS will be created"
}

variable "private_subnets" {
  description = "Private subnets for EKS nodes"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets for load balancers"
  type        = list(string)
}

variable "workers_security_group_id" {
  description = "Security group ID for worker nodes"
}
