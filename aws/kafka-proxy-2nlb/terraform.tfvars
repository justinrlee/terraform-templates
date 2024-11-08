environment_name = "justinrlee-apse1-kp"

region = "ap-southeast-1"

prefix = "10.39"

bastion_instance_type = "t3.xlarge"

ec2_public_key_name = "justinrlee-confluent-dev"

# Ubuntu 24.04 LTS amd64 20241011
ami = "ami-033d8247bc40e20b6"
# Ubuntu 24.04 LTS arm64 20241011
# ami = "ami-0f93cf7eb32b05cb2"

certificate_arn = "arn:aws:acm:ap-southeast-1:829250931565:certificate/9e919618-54b8-48ce-ae28-e144e201e964"

bootstrap_server = "pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092"

proxy_ami_id = "ami-033d8247bc40e20b6"
proxy_ec2_public_key_name = "justinrlee-confluent-dev"