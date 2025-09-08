locals {
  public_instances_r0 = flatten([
    for az, info in var.instances_r0 : [
      for i in range(info.public_count) : {
        "az"         = az,
        "i"          = i,
        "private_ip" = "${local.public_subnets_f3o_r0[az]}.${10 + i}",
        "subnet_id"  = aws_subnet.public_r0[az].id
      }
    ]
  ])

  public_instances_map_r0 = {
    for instance in local.public_instances_r0 :
    "${instance.az}_${instance.i}" => instance
  }
}

resource "aws_network_interface" "public_r0" {
  for_each = local.public_instances_map_r0

  private_ips = [each.value.private_ip]

  security_groups = [
    aws_security_group.allow_internal_r0.id,
    aws_security_group.allow_home_r0.id,
  ]

  subnet_id = each.value.subnet_id

  tags = {
    Name = "${var.environment_name}-if"
  }

  provider = aws.r0
}

resource "aws_instance" "public_r0" {
  for_each = local.public_instances_map_r0

  ami           = var.ami_r0
  instance_type = var.public_type
  key_name      = var.ec2_public_key_name_r0

  network_interface {
    network_interface_id = aws_network_interface.public_r0[each.key].id
    device_index         = 0
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.public_volume_size
    volume_type           = var.public_volume_type
    iops                  = var.public_volume_iops
    throughput            = var.public_volume_throughput
  }

  tags = {
    Name = "${var.environment_name}-public"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r0
}

output "generic_public_r0" {
  value = [for instance in aws_instance.public_r0 : "${instance.public_dns} : ${instance.private_dns}"]
}

output "generic_public_yaml_r0" {
  value = join(":\n    ", concat([""], [for instance in aws_instance.public_r0 : instance.public_dns], [""]))
}

output "generic_public_private_dns_yaml_r0" {
  value = join(":\n    ", concat([""], [for instance in aws_instance.public_r0 : instance.private_dns], [""]))
}

output "generic_public_private_ip_yaml_r0" {
  value = join(":\n    ", concat([""], [for instance in aws_instance.public_r0 : instance.private_ip], [""]))
}