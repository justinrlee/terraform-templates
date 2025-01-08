# General
environment_name = "justinrlee-apse1-envoy"
region = "ap-southeast-1"

# Input
proxy_ami_id = "ami-033d8247bc40e20b6"
proxy_ec2_public_key_name = "justinrlee-confluent-dev"
proxy_instance_type = "m6i.large"
certificate_arn = "arn:aws:acm:ap-southeast-1:829250931565:certificate/9e919618-54b8-48ce-ae28-e144e201e964"
route_53_domain = "confluent.justinrlee.io"
proxy_bootstrap = "kafka-apse1"
proxy_endpoints = {
    "az1" = "kafka-apse1-az1",
    "az2" = "kafka-apse1-az2",
    "az3" = "kafka-apse1-az3",
}
bootstrap_server = "pkc-3rom2w.ap-southeast-1.aws.confluent.cloud:9092"

# Input from prereqs output
zone_eip_mappings = {
  "az1" = "54.169.116.92"
  "az2" = "52.77.22.198"
  "az3" = "13.251.113.129"
}
zone_nlb_mappings = {
  "az1" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:loadbalancer/net/justinrlee-apse1-envoy-az1/de3edd53f470fd90"
  "az2" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:loadbalancer/net/justinrlee-apse1-envoy-az2/9b6ad6e63ba0fbc0"
  "az3" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:loadbalancer/net/justinrlee-apse1-envoy-az3/c336d446564921c4"
}
zone_private_subnet_mappings = {
  "az1" = "subnet-081a9050976b66656"
  "az2" = "subnet-0e6ef18a5d2bbdcfd"
  "az3" = "subnet-0b2edd66785d78f8b"
}
internal_security_group_id = "sg-019b334f99c9e466d"
nlb_security_group_id = "sg-0d2b3613714450b94"
vpc_id = "vpc-0a65552ff9369d55b"