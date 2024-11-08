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
    aws_eip.az1.public_ip,
    aws_eip.az2.public_ip,
    aws_eip.az3.public_ip,
  ]
}

# because we aren't using for_each on the aws_eip, need separate resource for each
resource "aws_route53_record" "az1" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az1"]}.${var.proxy_dns_zone}"
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az1.public_ip
  ] 
}
resource "aws_route53_record" "az2" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az2"]}.${var.proxy_dns_zone}"
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az2.public_ip
  ] 
}
resource "aws_route53_record" "az3" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.proxy_endpoints["az3"]}.${var.proxy_dns_zone}"
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az3.public_ip
  ] 
}