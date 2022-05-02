
module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.1.0"

  name = "${var.environment_name}-${var.region_short}"

  cidr = "${var.prefix}.0.0/16"

  azs            = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets = ["${var.prefix}.1.0/24", "${var.prefix}.2.0/24", "${var.prefix}.3.0/24"]

  enable_ipv6          = false
  enable_dns_hostnames = true

  enable_nat_gateway = false
  single_nat_gateway = false

  public_subnet_tags = {
    Name = "${var.environment_name}-public"
  }

  vpc_tags = {
    Name = "${var.environment_name}-${var.region_short}"
  }
}