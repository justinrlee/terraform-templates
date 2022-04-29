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

# TODO: if fewer than three brokers, set all default replication factors to 0 (and disable other features?)
output "inventory" {
  value = merge({
    all = {
      vars = merge({
        ansible_connection = "ssh"
        ansible_user       = "ubuntu"
        ansible_become     = true
        # ssl_enabled = true
        validate_hosts = false
        # regenerate_ca = false
        # kafka_broker_custom_properties = merge({
        #   "replica.selector.class" = "org.apache.kafka.common.replica.RackAwareReplicaSelector"
        # },
        # var.kafka_broker_custom_properties
        # )
        control_center_custom_properties = {
          "confluent.controlcenter.mode.enable" = var.control_center_mode
        }
        },
        # var.public_listener_port != null ? {
        #   kafka_broker_custom_listeners : {
        #     client_listener: {
        #       name: "CLIENT"
        #       port: var.public_listener_port
        #     }
        #   }
        # } : {}
      )
    },
    zookeeper = {
      hosts = merge(
        zipmap(
          aws_instance.zookeepers.*.private_dns,
          [
            for i in range(length(aws_instance.zookeepers.*.private_dns)) : { zookeeper_id : i }
          ]
        ),

      )
    },
    kafka_broker = {
      hosts = merge(
        zipmap(
          # aws_instance.brokers.*.private_dns, 
          local.merged_broker_private_dns,
          [
            for i in range(length(local.merged_broker_private_dns)) : merge({
              broker_id : i + 100,
              # kafka_broker_custom_properties: {
              #   "broker.rack": (i < var.broker_count) ? var.region : "${var.region}-o"
              # }
              },
              # var.public_listener_port != null ? {
              #   kafka_broker_custom_listeners: {
              #     client_listener: {
              #       hostname: aws_instance.brokers[i].public_dns
              #     }
              #   }
              # } : {}
            )
          ]
        ),
      )
    },
    schema_registry = {
      hosts = merge(
        {
          for instance in aws_instance.schema_registries.*.private_dns :
          instance => null
        },
      )
    },
    control_center = {
      hosts = merge(
        {
          for instance in aws_instance.control_centers.*.private_dns :
          instance => null
        },
      )
      # vars = {
      #   kafka_connect_cluster_ansible_group_names = [for connect_group in module.connect_workers: "connect_${connect_group.label}"],
      #   ksql_cluster_ansible_group_names = [for connect_group in module.connect_workers: "ksql_${connect_group.label}"]
      # }
    },
    # kafka_connect = {
    #   children = {
    #     for connect_cluster in module.connect_workers:
    #       "x_connect_${connect_cluster.label}" => null
    #   }
    # },
    # ksql = {
    #   children = {
    #     for ksqldb_cluster in module.ksqldb_clusters:
    #       "x_ksql_${ksqldb_cluster.label}" => null
    #   }
    # }
    },
    # {
    #   for connect_cluster in module.connect_workers:
    #   "x_connect_${connect_cluster.label}" => {
    #     vars: {
    #       kafka_connect_group_id: connect_cluster.label
    #     },
    #     hosts = merge(
    #       {
    #         for worker in connect_cluster.private_dns[0]:
    #           worker => null
    #       },
    #     )
    #   }
    # },
    # {
    #   for ksqldb_cluster in module.ksqldb_clusters:
    #   "x_ksql_${ksqldb_cluster.label}" => {
    #     vars: {
    #       ksql_service_id: "${ksqldb_cluster.label}"
    #     },
    #     hosts = merge(
    #       {
    #         for worker in ksqldb_cluster.private_dns[0]:
    #           worker => null
    #       },
    #     )
    #   }
    # }
  )
}