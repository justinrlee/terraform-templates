output "bastion" {
  value = aws_instance.bastion.public_ip
}

output "bootstrap_server" {
  value = confluent_kafka_cluster.main.bootstrap_endpoint
}

output "bootstrap_proxy" {
  value = "${local.proxy_kafka_endpoint}:9092"
}

data "aws_instances" "proxy" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.proxy.name
  }

  instance_state_names = ["running"]
}

output "asg_ips" {
  value = data.aws_instances.proxy.private_ips
}