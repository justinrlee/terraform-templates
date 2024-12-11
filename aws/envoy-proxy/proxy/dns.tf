# Use an existing DNS zone, put seven records in it:
# * one record for the bootstrap (points at all 6 NLBs)
# * one record for each NLB

data "aws_route53_zone" "primary" {
  name = var.route_53_domain
  #   private_zone = true
}

resource "aws_route53_record" "kafka" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_bootstrap}.${var.route_53_domain}"
  type    = "A"
  ttl     = 60
  records = [
    var.zone_eip_mappings["az1"],
    var.zone_eip_mappings["az2"],
    var.zone_eip_mappings["az3"],
  ]
}

# because we aren't using for_each on the aws_eip, need separate resource for each
resource "aws_route53_record" "az1" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az1"]}.${var.route_53_domain}"
  type    = "A"
  ttl     = 60
  records = [
    var.zone_eip_mappings["az1"]
  ] 
}
resource "aws_route53_record" "az2" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az2"]}.${var.route_53_domain}"
  type    = "A"
  ttl     = 60
  records = [
    var.zone_eip_mappings["az2"]
  ] 
}
resource "aws_route53_record" "az3" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az3"]}.${var.route_53_domain}"
  type    = "A"
  ttl     = 60
  records = [
    var.zone_eip_mappings["az3"]
  ] 
}