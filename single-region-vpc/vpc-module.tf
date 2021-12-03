
module "vpc_r0s" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.1.0"

  name = "${var.cluster_name}-${var.regions_short[0]}"

  cidr = "${var.prefixes[0]}.0.0/16"

  azs             = ["${var.regions[0]}a", "${var.regions[0]}b", "${var.regions[0]}c"]
  private_subnets = ["${var.prefixes[0]}.101.0/24", "${var.prefixes[0]}.102.0/24", "${var.prefixes[0]}.103.0/24"]
  public_subnets  = ["${var.prefixes[0]}.1.0/24", "${var.prefixes[0]}.2.0/24", "${var.prefixes[0]}.3.0/24"]

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
    Name = "${var.cluster_name}-${var.regions_short[0]}"
  }

  providers = {
    aws = aws.r0a
  }
}