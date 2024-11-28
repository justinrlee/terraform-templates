locals {
    public_instances_r1 = flatten([
        for az,info in var.instances_r1: [
            for i in range(info.public_count): {
                "az" = az,
                "i" = i,
                "private_ip" = "${local.public_subnets_f3o_r1[az]}.${10 + i}",
                "subnet_id" = aws_subnet.public_r1[az].id
            }
        ]
    ])

    public_instances_map_r1 = {
        for instance in local.public_instances_r1:
            "${instance.az}_${instance.i}" => instance
    }
}

resource "aws_network_interface" "public_r1" {
  for_each = local.public_instances_map_r1

  private_ips = [each.value.private_ip]

  security_groups = [
    aws_security_group.allow_internal_r1.id,
    aws_security_group.allow_home_r1.id,
  ]

  subnet_id = each.value.subnet_id

  tags = {
    Name = "${var.environment_name}-if"
  }

  provider = aws.r1
}

resource "aws_instance" "public_r1" {
  for_each = local.public_instances_map_r1

  ami                         = var.ami_r1
  instance_type               = var.public_type
  key_name                    = var.ec2_public_key_name_r1

  network_interface {
    network_interface_id = aws_network_interface.public_r1[each.key].id
    device_index = 0
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.public_volume_size
  }

  tags = {
    Name = "${var.environment_name}-public"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r1
}

output "generic_public_r1" {
  value = [for instance in aws_instance.public_r1: "${instance.public_dns} : ${instance.private_dns}"]
}

output "generic_public_yaml_r1" {
  value = join(":\n    ", concat([""], [for instance in aws_instance.public_r1: instance.public_dns], [""]))
}

output "generic_public_private_dns_yaml_r1" {
  value = join(":\n    ", concat([""], [for instance in aws_instance.public_r1: instance.private_dns], [""]))
}

output "generic_public_private_ip_yaml_r1" {
  value = join(":\n    ", concat([""], [for instance in aws_instance.public_r1: instance.private_ip], [""]))
}