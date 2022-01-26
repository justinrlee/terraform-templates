
module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.1.0"

  name = "${var.cluster_name}-${var.region_short}"

  cidr = "${var.prefix}.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["${var.prefix}.101.0/24", "${var.prefix}.102.0/24", "${var.prefix}.103.0/24"]
  public_subnets  = ["${var.prefix}.1.0/24", "${var.prefix}.2.0/24", "${var.prefix}.3.0/24"]

  enable_ipv6 = false
  enable_dns_hostnames = true

  enable_nat_gateway = true
  single_nat_gateway = false

  public_subnet_tags = {
    Name = "${var.cluster_name}-public"
  }

  tags = {
    Owner       = var.owner_name
    Environment = var.cluster_name
    Provenance = "Single-Region Terraform for ${var.cluster_name}"
  }

  vpc_tags = {
    Name = "${var.cluster_name}-${var.region_short}"
  }

  # providers = {
  #   aws = aws.r0a
  # }
}