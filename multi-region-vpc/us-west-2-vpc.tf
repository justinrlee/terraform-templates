provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
}

module "vpc_usw2" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.1.0"

  name = "${var.cluster_name}-usw2"

  cidr = "${var.usw2_slash16}.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["${var.usw2_slash16}.101.0/24", "${var.usw2_slash16}.102.0/24", "${var.usw2_slash16}.103.0/24"]
  public_subnets  = ["${var.usw2_slash16}.1.0/24", "${var.usw2_slash16}.2.0/24", "${var.usw2_slash16}.3.0/24"]

  enable_ipv6 = false
  enable_dns_hostnames = true

  enable_nat_gateway = false
  single_nat_gateway = false

  public_subnet_tags = {
    Name = "${var.cluster_name}-public"
  }

  tags = {
    Owner       = var.owner_name
    Environment = var.cluster_name
    Provenance = "Multi-Region Terraform for ${var.cluster_name}"
  }

  vpc_tags = {
    Name = "${var.cluster_name}-usw2"
  }

  providers = {
    aws = aws.us-west-2
  }
}