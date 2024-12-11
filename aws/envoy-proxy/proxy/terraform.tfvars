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

# Input from prereqs
zone_eip_mappings = {
  "az1" = "18.138.156.138"
  "az2" = "18.136.63.206"
  "az3" = "52.76.152.172"
}
zone_nlb_mappings = {
  "az1" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:loadbalancer/net/justinrlee-apse1-envoy-az1/17e68329977f32a5"
  "az2" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:loadbalancer/net/justinrlee-apse1-envoy-az2/905ad33eb0a3031e"
  "az3" = "arn:aws:elasticloadbalancing:ap-southeast-1:829250931565:loadbalancer/net/justinrlee-apse1-envoy-az3/506e590469f85e51"
}
zone_private_subnet_mappings = {
  "az1" = "subnet-0cc5433a979e21bab"
  "az2" = "subnet-0d89cbf582a55bec0"
  "az3" = "subnet-06b597bcea434d4f8"
}
nlb_security_group_id = "sg-098ebb60112f189f4"
internal_security_group_id = "sg-0deb962e7497de1e2"
vpc_id = "vpc-0b5602ecea5a63030"