module "eks" {

  source = "terraform-aws-modules/eks/aws"

  version = "~>21.0"

  cluster_name = var.cluster_name

  cluster_version = "1.33"

  subnet_ids = data.aws_subnets.default.ids

  vpc_id = data.aws_vpc.default.id

  eks_managed_node_groups = {

    worker = {

      desired_size = 2

      max_size = 3

      min_size = 1

      instance_types = ["t3.medium"]
    }
  }
}

data "aws_vpc" "default" {

  default = true
}

data "aws_subnets" "default" {

  filter {

    name="vpc-id"

    values=[data.aws_vpc.default.id]
  }
}
