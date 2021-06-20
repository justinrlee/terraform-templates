
module "vpc_r1s" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.1.0"

  name = "${var.cluster_name}-${var.regions_short[1]}"

  cidr = "${var.prefixes[1]}.0.0/16"

  azs             = ["${var.regions[1]}a", "${var.regions[1]}b", "${var.regions[1]}c"]
  private_subnets = ["${var.prefixes[1]}.101.0/24", "${var.prefixes[1]}.102.0/24", "${var.prefixes[1]}.103.0/24"]
  public_subnets  = ["${var.prefixes[1]}.1.0/24", "${var.prefixes[1]}.2.0/24", "${var.prefixes[1]}.3.0/24"]

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
    Name = "${var.cluster_name}-${var.regions_short[1]}"
  }

  providers = {
    aws = aws.r1a
  }
}