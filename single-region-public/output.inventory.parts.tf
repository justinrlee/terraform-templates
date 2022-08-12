locals {
  merged_broker_private_dns = (var.binpack_zookeeper_brokers ?
    (local.total_brokers >= var.zookeeper_count ?
      concat(aws_instance.zookeepers.*.private_dns, aws_instance.brokers.*.private_dns) :
      slice(aws_instance.zookeepers.*.private_dns, 0, local.total_brokers)
    )
  : aws_instance.brokers.*.private_dns)

  # three scenarios if binpacking:
  # more brokers than zookeepers: combine broekrs and zookeepers
  # same number of brokers and zookeepers: combine brokers and zookeepers (will be no bk, so this is fine)
  # fewer brokers than zookeepers: use first x zookeepers
}

output inventory_bastion_ldap {
  value = {
    all = {
      vars = {
        kafka_broker_custom_properties = {
          "ldap.java.naming.provider.url" = "ldap://${aws_instance.bastions[0].private_dns}:10389"
        }
      }
    }
  }
}