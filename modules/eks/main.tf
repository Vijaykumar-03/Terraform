resource "aws_launch_template" "eks_nodes" {
  name_prefix = "eks-worker-"

  key_name = "terraform-key"

  update_default_version = true

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "eks-worker"
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.24"

  name               = var.cluster_name
  kubernetes_version = "1.33"

  authentication_mode = "API_AND_CONFIG_MAP"

  endpoint_public_access  = true
  endpoint_private_access = false

  enable_irsa = true

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids

  eks_managed_node_groups = {
    worker = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.micro"]

      desired_size = 2
      min_size     = 1
      max_size     = 3

      capacity_type = "ON_DEMAND"

      launch_template_id      = aws_launch_template.eks_nodes.id
      launch_template_version = "$Latest"

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
