/*

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws    = { source = "hashicorp/aws" }
    random = { source = "hashicorp/random" }
  }
}

*/
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

resource "random_string" "suffix" {
  length  = 6
  special = false
}

locals {
  cluster_name = "mr-demo-eks-${random_string.suffix.result}"
}

# --- VPC Module ---
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name                 = "${local.cluster_name}-vpc"
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.10.0/24", "10.0.11.0/24"]
  private_subnets      = ["10.0.20.0/24", "10.0.21.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

# --- Custom Security Group for Worker Nodes ---
resource "aws_security_group" "workers_sg" {
  name_prefix = "${local.cluster_name}-workers-sg-"
  description = "Security group for EKS worker nodes"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "workers_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.workers_sg.id
  cidr_blocks       = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

resource "aws_security_group_rule" "workers_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.workers_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "workers_security_group_id" {
  value = aws_security_group.workers_sg.id
}
