# Use an existing DNS zone, put seven records in it:
# * one record for the bootstrap (points at all 6 NLBs)
# * one record for each NLB

data "aws_route53_zone" "primary" {
  name = var.proxy_dns_zone
  #   private_zone = true
}

resource "aws_route53_record" "kafka" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_bootstrap}.${var.proxy_dns_zone}"
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az1_a.public_ip,
    aws_eip.az2_a.public_ip,
    aws_eip.az3_a.public_ip,
    aws_eip.az1_b.public_ip,
    aws_eip.az2_b.public_ip,
    aws_eip.az3_b.public_ip,
  ]
}

# because we aren't using for_each on the aws_eip, need separate resource for each
resource "aws_route53_record" "az1_a" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az1_a"]}.${var.proxy_dns_zone}"
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az1_a.public_ip
  ] 
}
resource "aws_route53_record" "az2_a" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az2_a"]}.${var.proxy_dns_zone}"
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az2_a.public_ip
  ] 
}
resource "aws_route53_record" "az3_a" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az3_a"]}.${var.proxy_dns_zone}"
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az3_a.public_ip
  ] 
}
resource "aws_route53_record" "az1_b" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az1_b"]}.${var.proxy_dns_zone}"
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az1_b.public_ip
  ] 
}
resource "aws_route53_record" "az2_b" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az2_b"]}.${var.proxy_dns_zone}"
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az2_b.public_ip
  ] 
}
resource "aws_route53_record" "az3_b" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az3_b"]}.${var.proxy_dns_zone}"
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az3_b.public_ip
  ] 
}