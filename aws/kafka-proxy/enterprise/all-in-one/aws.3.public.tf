data "aws_route53_zone" "primary" {
  name = var.route_53_domain
}

locals {
  proxy_kafka_endpoint = "${var.certificate}.${var.subdomain}.${var.route_53_domain}"
}

resource "aws_acm_certificate" "kafka" {
  domain_name = local.proxy_kafka_endpoint

  validation_method = "DNS"

  key_algorithm = "RSA_2048"

  validation_option {
    domain_name = local.proxy_kafka_endpoint
    validation_domain = var.route_53_domain
  }
}

resource "aws_route53_record" "kafka_certificate" {
  for_each = {
    for dvo in aws_acm_certificate.kafka.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primary.zone_id
}

resource "aws_acm_certificate_validation" "kafka" {
  certificate_arn         = aws_acm_certificate.kafka.arn
  validation_record_fqdns = [for record in aws_route53_record.kafka_certificate : record.fqdn]
}

resource "aws_route53_record" "kafka" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.proxy_kafka_endpoint
  type    = "A"
  ttl     = 60
  records = [
    for zone, eip in aws_eip.nlb: eip.public_ip
  ]
}