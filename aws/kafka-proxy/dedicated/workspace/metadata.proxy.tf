
data "aws_route53_zone" "primary" {
  name = var.route_53_domain
}

locals {
  proxy_kafka_endpoint = "${var.proxy_kafka}.${var.subdomain}.${var.route_53_domain}"
  proxy_zonal_endpoints = {
    for k,v in var.proxy_zonal: 
      k => "${v}.${var.subdomain}.${var.route_53_domain}"
  }
}