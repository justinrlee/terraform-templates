# General
environment_name = "justinrlee-apse1-envoy"
region = "us-east-1"

# Input
# use1 Ubuntu 24.04 LTS amd64
proxy_ami_id = "ami-079cb33ef719a7b78"
# use1 Ubuntu 24.04 LTS arm64
# proxy_ami_id = "ami-04474687c34a061cf"

proxy_ec2_public_key_name = "justinrlee-confluent-dev"
proxy_instance_type = "m6i.large"
certificate_arn = "arn:aws:acm:us-east-1:829250931565:certificate/433bc326-d44c-43bc-81aa-4055ae8a8165"
route_53_domain = "confluent.justinrlee.io"
proxy_bootstrap = "kafka-use1-esku"
bootstrap_server = "lkc-712po1.us-east-1.aws.private.confluent.cloud:9092"

# proxy_endpoints = {
#     "az1" = "kafka-apse1-az1",
#     "az2" = "kafka-apse1-az2",
#     "az3" = "kafka-apse1-az3",
# }
# bootstrap_server = "pkc-3rom2w.ap-southeast-1.aws.confluent.cloud:9092"

# Input from prereqs output


internal_security_group_id = "sg-06c109b38602cc997"
nlb_arn = "arn:aws:elasticloadbalancing:us-east-1:829250931565:loadbalancer/net/justinrlee-use1-kp/3c518735117cc081"
nlb_security_group_id = "sg-073bd60cc77d5737a"

vpc_id = "vpc-0341df7e66264c599"
zone_eip_mappings = {
  "az1" = "50.19.222.252"
  "az2" = "52.23.72.205"
  "az4" = "98.85.66.37"
  "az5" = "18.210.101.60"
  "az6" = "3.222.54.206"
}
zone_private_subnet_mappings = {
  "az1" = "subnet-0811fc4bb86319813"
  "az2" = "subnet-0a02a547af3b27b4a"
  "az4" = "subnet-0472d89a42b54f640"
  "az5" = "subnet-0e05a019d7661bcfc"
  "az6" = "subnet-04fb8561b8129247a"
}