# Todo: parameterize subnets
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.16"

  name           = var.environment_name
  cidr           = "172.16.0.0/16"
  azs            = var.zones
  public_subnets = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.environment_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
    "x"                                             = "y"
  }

  tags = {
    owner_email = var.owner
    Terraform   = true
  }
}