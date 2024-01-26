
module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v5.5.1"

  name = "${var.environment_name}-${var.region_short}"

  cidr = "${var.prefix}.0.0/16"

  azs = [for zone in var.zones : "${var.region_short}-az${zone}"]
  public_subnets = concat(
    [for zone in var.zones : "${var.prefix}.${zone + 10}.0/24"],
    [for zone in var.zones : "${var.prefix}.${zone + 20}.0/24"],
  )

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