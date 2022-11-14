# Todo: parameterize subnets
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # version = "3.16.1"
  version = "~> 3.16"

  name           = var.environment_name
  cidr           = "172.16.0.0/16"
  azs            = var.zones
  public_subnets = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  # private_subnets      = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.environment_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
    "x"                                             = "y"
  }

  # private_subnet_tags = {
  #   "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  #   "kubernetes.io/role/internal-elb"             = "1"
  # }

  tags = {
    owner_email = var.owner
    Terraform   = true
  }
}

# locals {
#   vpc_id = module.vpc.vpc_id
# }