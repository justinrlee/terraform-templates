provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

module "vpc_use1" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.1.0"

  name = "${var.cluster_name}-use1"

  cidr = "${var.use1_slash16}.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["${var.use1_slash16}.101.0/24", "${var.use1_slash16}.102.0/24", "${var.use1_slash16}.103.0/24"]
  public_subnets  = ["${var.use1_slash16}.1.0/24", "${var.use1_slash16}.2.0/24", "${var.use1_slash16}.3.0/24"]

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
    Name = "${var.cluster_name}-use1"
  }

  providers = {
    aws = aws.us-east-1
  }
}