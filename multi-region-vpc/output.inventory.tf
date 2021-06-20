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
        kafka_broker_custom_properties = {
          "replica.selector.class" = "org.apache.kafka.common.replica.RackAwareReplicaSelector"
        }
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
    }
    zookeeper = {
      hosts = merge(
        zipmap(
          aws_instance.zk_r0s.*.private_dns, 
          [
            for i in range(length(aws_instance.zk_r0s.*.private_dns)): null
          ]
        ),

        zipmap(
          aws_instance.zk_r1s.*.private_dns, [
            for i in range(length(aws_instance.zk_r1s.*.private_dns)): null
          ]
        ),

        zipmap(
          aws_instance.zk_r2s.*.private_dns, [
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
                "broker.rack": var.regions[0]
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
                "broker.rack": var.regions[1]
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
                "broker.rack": var.regions[2]
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
    }
  }   
}