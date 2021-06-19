
module "vpc_r0s" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.1.0"

  name = "${var.cluster_name}-${var.r0s}"

  cidr = "${var.r0s_prefix16}.0.0/16"

  azs             = ["${var.r0}a", "${var.r0}b", "${var.r0}c"]
  private_subnets = ["${var.r0s_prefix16}.101.0/24", "${var.r0s_prefix16}.102.0/24", "${var.r0s_prefix16}.103.0/24"]
  public_subnets  = ["${var.r0s_prefix16}.1.0/24", "${var.r0s_prefix16}.2.0/24", "${var.r0s_prefix16}.3.0/24"]

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
    Name = "${var.cluster_name}-${var.r0s}"
  }

  providers = {
    aws = aws.r0a
  }
}