output "bastion" {
  value = aws_instance.bastion.public_ip
}

# output "bootstrap_server" {
#   value = trimprefix(confluent_kafka_cluster.main.bootstrap_endpoint,"SASL_SSL://")
# }

output "regional_endpoint" {
  value = "${local.proxy_kafka_endpoint}"
}

output "zonal_endpoint" {
  value = {
    for zone, x in var.proxy_zonal:
      "${var.region_short}-${zone}" => local.proxy_zonal_endpoints[zone]
  }
}

output "zone_broker_offsets" {
  value = local.zone_broker_offsets
}

output "zones" {
  value = [
    for z in confluent_kafka_cluster.main.dedicated[0].zones: z
  ]
}

output "target_groups" {
  value = merge(
    {
      "${var.region_short}-az1-9092": {
        zone: "${var.region_short}-az1",
        port: "9092",
        arn: aws_lb_target_group.bootstrap_az1.arn,
      },
      "${var.region_short}-az2-9092": {
        zone: "${var.region_short}-az2",
        port: "9092",
        arn: aws_lb_target_group.bootstrap_az2.arn,
      },
      "${var.region_short}-az3-9092": {
        zone: "${var.region_short}-az3",
        port: "9092",
        arn: aws_lb_target_group.bootstrap_az3.arn,
      },
    },
    {
      for port,target_group in aws_lb_target_group.broker_az1:
        "${var.region_short}-az1-${port}" => {
          zone = "${var.region_short}-az1"
          port: port
          arn: target_group.arn
        }
    },
    {
      for port,target_group in aws_lb_target_group.broker_az2:
        "${var.region_short}-az2-${port}" => {
          zone = "${var.region_short}-az2"
          port: port
          arn: target_group.arn
        }
    },
    {
      for port,target_group in aws_lb_target_group.broker_az3:
        "${var.region_short}-az3-${port}" => {
          zone = "${var.region_short}-az3"
          port: port
          arn: target_group.arn
        }
    },
  )
  # value = {
  #   "${var.region_short}-az1" = merge({
  #     for port,target_group in aws_lb_target_group.broker_az1:
  #       port => target_group.arn
  #   },{
  #     "9092": aws_lb_target_group.bootstrap_az1.arn
  #   }),
  #   "${var.region_short}-az2" = merge({
  #     for port,target_group in aws_lb_target_group.broker_az2:
  #       port => target_group.arn
  #   },{
  #     "9092": aws_lb_target_group.bootstrap_az2.arn
  #   }),
  #   "${var.region_short}-az3" = merge({
  #     for port,target_group in aws_lb_target_group.broker_az3:
  #       port => target_group.arn
  #   },{
  #     "9092": aws_lb_target_group.bootstrap_az3.arn
  #   }),
  # }
}

# output "target_group_mapping" {
#   value = {
#     ""
#   }
# }

# data "aws_instances" "proxy_az1" {
#   instance_tags = {
#     "aws:autoscaling:groupName" = aws_autoscaling_group.proxy_az1.name
#   }
#   instance_state_names = ["running"]
# }

# data "aws_instances" "proxy_az2" {
#   instance_tags = {
#     "aws:autoscaling:groupName" = aws_autoscaling_group.proxy_az2.name
#   }
#   instance_state_names = ["running"]
# }

# data "aws_instances" "proxy_az3" {
#   instance_tags = {
#     "aws:autoscaling:groupName" = aws_autoscaling_group.proxy_az3.name
#   }
#   instance_state_names = ["running"]
# }

# output "asg_ips" {
#   value = {
#     az1 = data.aws_instances.proxy_az1.private_ips,
#     az2 = data.aws_instances.proxy_az2.private_ips,
#     az3 = data.aws_instances.proxy_az3.private_ips,
#   }
# }