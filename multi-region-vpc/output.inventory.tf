output inventory {
  value = {
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
          aws_instance.zk_r0s.*.private_dns,
          [
            for i in range(length(aws_instance.zk_r0s.*.private_dns)): null
          ]
        ),

        zipmap(
          aws_instance.zk_r1s.*.private_dns,
          [
            for i in range(length(aws_instance.zk_r1s.*.private_dns)): null
          ]
        ),

        zipmap(
          aws_instance.zk_r2s.*.private_dns,
          [
            for i in range(length(aws_instance.zk_r2s.*.private_dns)): null
          ]
        )
      )
    },
    kafka_broker = {
      hosts = merge(
        zipmap(
          aws_instance.brokers_r0s.*.private_dns, 
          [
            for i in range(length(aws_instance.brokers_r0s.*.private_dns)): merge({
              broker_id: i + 100,
              kafka_broker_custom_properties: {
                "broker.rack": (i < var.broker_counts[0]) ? var.regions[0] : "${var.regions[0]}-o"
              }
            },
            var.public_listener_port != null ? {
              kafka_broker_custom_listeners: {
                client_listener: {
                  hostname: aws_instance.brokers_r0s[i].public_dns
                }
              }
            } : {}
            )
          ]
        ),

        zipmap(
          aws_instance.brokers_r1s.*.private_dns, [
            for i in range(length(aws_instance.brokers_r1s.*.private_dns)): merge({
              broker_id: i + 200,
              kafka_broker_custom_properties: {
                "broker.rack": (i < var.broker_counts[1]) ? var.regions[1] : "${var.regions[1]}-o"
              }
            },
            var.public_listener_port != null ? {
              kafka_broker_custom_listeners: {
                client_listener: {
                  hostname: aws_instance.brokers_r1s[i].public_dns
                }
              }
            } : {}
            )
          ]
        ),

        zipmap(
          aws_instance.brokers_r2s.*.private_dns, [
            for i in range(length(aws_instance.brokers_r2s.*.private_dns)): merge({
              broker_id: i + 300,
              kafka_broker_custom_properties: {
                "broker.rack": (i < var.broker_counts[2]) ? var.regions[2] : "${var.regions[2]}-o"
              }
            },
            var.public_listener_port != null ? {
              kafka_broker_custom_listeners: {
                client_listener: {
                  hostname: aws_instance.brokers_r2s[i].public_dns
                }
              }
            } : {}
            )
          ]
        )
      )
    },
    schema_registry = {
      hosts = merge(
        zipmap(
          aws_instance.schema_registry_r0s.*.private_dns,
          [
            for i in range(length(aws_instance.schema_registry_r0s.*.private_dns)): null
          ]
        ),

        zipmap(
          aws_instance.schema_registry_r1s.*.private_dns,
          [
            for i in range(length(aws_instance.schema_registry_r1s.*.private_dns)): null
          ]
        ),

        zipmap(
          aws_instance.schema_registry_r2s.*.private_dns,
          [
            for i in range(length(aws_instance.schema_registry_r2s.*.private_dns)): null
          ]
        )
      )
    },
    control_center = {
      hosts = merge(
        zipmap(
          aws_instance.control_center_r0s.*.private_dns,
          [
            for i in range(length(aws_instance.control_center_r0s.*.private_dns)): null
          ]
        ),

        zipmap(
          aws_instance.control_center_r1s.*.private_dns,
          [
            for i in range(length(aws_instance.control_center_r1s.*.private_dns)): null
          ]
        ),

        zipmap(
          aws_instance.control_center_r2s.*.private_dns,
          [
            for i in range(length(aws_instance.control_center_r2s.*.private_dns)): null
          ]
        )
      )
    },
  }   
}