output inventory {
  value = merge({
    all = {
      vars = merge ({
        ansible_connection = "ssh"
        ansible_user = "ubuntu"
        ansible_become = true
        ssl_enabled = true
        validate_hosts = false
        regenerate_ca = false
        kafka_broker_custom_properties = merge({
          "replica.selector.class" = "org.apache.kafka.common.replica.RackAwareReplicaSelector"
        },
        var.kafka_broker_custom_properties
        )
      },
      var.public_listener_port != null ? {
        kafka_broker_custom_listeners : {
          client_listener: {
            name: "CLIENT"
            port: var.public_listener_port
          }
        }
      } : {}
      )
    },
    zookeeper = {
      hosts = merge(
        zipmap(
          aws_instance.zookeepers.*.private_dns,
          [
            for i in range(length(aws_instance.zookeepers.*.private_dns)): null
          ]
        ),

      )
    },
    kafka_broker = {
      hosts = merge(
        zipmap(
          aws_instance.brokers.*.private_dns, 
          [
            for i in range(length(aws_instance.brokers.*.private_dns)): merge({
              broker_id: i + 100,
              kafka_broker_custom_properties: {
                "broker.rack": (i < var.broker_counts[0]) ? var.region : "${var.region}-o"
              }
            },
            var.public_listener_port != null ? {
              kafka_broker_custom_listeners: {
                client_listener: {
                  hostname: aws_instance.brokers[i].public_dns
                }
              }
            } : {}
            )
          ]
        ),
      )
    },
    schema_registry = {
      hosts = merge(
        {
          for instance in aws_instance.schema_registries.*.private_dns:
            instance => null
        },
      )
    },
    control_center = {
      hosts = merge(
        {
          for instance in aws_instance.control_centers.*.private_dns:
            instance => null
        },
      )
      # vars = {
      #   kafka_connect_cluster_ansible_group_names = [for connect_group in module.connect_workers: "connect_${connect_group.label}"],
      #   ksql_cluster_ansible_group_names = [for connect_group in module.connect_workers: "ksql_${connect_group.label}"]
      # }
    },
    kafka_connect = {
      children = {
        for connect_cluster in module.connect_workers:
          "x_connect_${connect_cluster.label}" => null
      }
    },
    ksql = {
      children = {
        for ksqldb_cluster in module.ksqldb_clusters:
          "x_ksql_${ksqldb_cluster.label}" => null
      }
    }
  },
  {
    for connect_cluster in module.connect_workers:
    "x_connect_${connect_cluster.label}" => {
      vars: {
        kafka_connect_group_id: connect_cluster.label
      },
      hosts = merge(
        {
          for worker in connect_cluster.private_dns[0]:
            worker => null
        },
      )
    }
  },
  {
    for ksqldb_cluster in module.ksqldb_clusters:
    "x_ksql_${ksqldb_cluster.label}" => {
      vars: {
        ksql_service_id: "${ksqldb_cluster.label}"
      },
      hosts = merge(
        {
          for worker in ksqldb_cluster.private_dns[0]:
            worker => null
        },
      )
    }
  }
  )   
}