module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.24"

  name               = var.cluster_name
  kubernetes_version = "1.33"

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids

  endpoint_public_access = true

  eks_managed_node_groups = {
    worker = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      capacity_type = "ON_DEMAND"

      labels = {
        role = "worker"
      }

      tags = {
        Name = "devops-worker"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
