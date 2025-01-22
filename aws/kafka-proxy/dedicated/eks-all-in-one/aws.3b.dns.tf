resource "aws_route53_record" "kafka" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.proxy_kafka_endpoint
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az1.public_ip,
    aws_eip.az2.public_ip,
    aws_eip.az3.public_ip,
    # aws_eip.az4.public_ip,
  ]
}

resource "aws_route53_record" "kafka_az1" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.proxy_zonal_endpoints["az1"]
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az1.public_ip,
  ]
}

resource "aws_route53_record" "kafka_az2" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.proxy_zonal_endpoints["az2"]
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az2.public_ip,
  ]
}

resource "aws_route53_record" "kafka_az3" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.proxy_zonal_endpoints["az3"]
  type    = "A"
  ttl     = 60
  records = [
    aws_eip.az3.public_ip,
  ]
}

# resource "aws_route53_record" "kafka_az4" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = local.proxy_zonal_endpoints["az4"]
#   type    = "A"
#   ttl     = 60
#   records = [
#     aws_eip.az4.public_ip,
#   ]
# }
