module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = "devops-ecr"
}

module "ec2" {
  source = "./modules/ec2"

  ami           = "ami-0c8dc555a7e1ca7a3"
  instance_type = "t3.micro"
  key_name      = "terraform-key"
}

module "eks" {
  source = "./modules/eks"

  cluster_name = "devops-eks"
}

module "lambda" {
  source = "./modules/lambda"

  function_name = "user-registration"

  role_arn = module.iam.lambda_role_arn
}
