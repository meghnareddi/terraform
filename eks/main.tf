terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.17.0" # or latest
    }
  }
}


provider "aws" {
  region = var.aws_region
}


# --- IAM Role for Worker Nodes ---
resource "aws_iam_role" "worker_role" {
  name = "${var.cluster_name}-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach required IAM policies
resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# --- EKS Module ---
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = var.private_subnets
  vpc_id          = var.vpc_id

  enable_irsa = true

  eks_managed_node_group_defaults = {
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [var.workers_security_group_id]
  }

  eks_managed_node_groups = {
    primary = {
      desired_size = 2
      min_size     = 1
      max_size     = 3
      iam_role_arn = aws_iam_role.worker_role.arn
    }
  }

  tags = {
    Project = "demo"
  }
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
output "eks_ca_data" {
  value = module.eks.cluster_certificate_authority_data
}
