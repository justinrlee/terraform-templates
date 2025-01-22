output "bastion" {
  value = aws_instance.bastion.public_ip
}

output "bootstrap_server" {
  value = trimprefix(confluent_kafka_cluster.main.bootstrap_endpoint,"SASL_SSL://")
}

output "bootstrap_proxy" {
  value = "${local.proxy_kafka_endpoint}:9092"
}

data "aws_instances" "proxy_az1" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.proxy_az1.name
  }
  instance_state_names = ["running"]
}

data "aws_instances" "proxy_az2" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.proxy_az2.name
  }
  instance_state_names = ["running"]
}

data "aws_instances" "proxy_az3" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.proxy_az3.name
  }
  instance_state_names = ["running"]
}

output "asg_ips" {
  value = {
    az1 = data.aws_instances.proxy_az1.private_ips,
    az2 = data.aws_instances.proxy_az2.private_ips,
    az3 = data.aws_instances.proxy_az3.private_ips,
  }
}