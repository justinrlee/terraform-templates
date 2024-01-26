# TODO: if fewer than three brokers, set all default replication factors to 0 (and disable other features?)
output "inventory" {
  value = {
    all = {
      vars = {
        ansible_connection = "ssh"
        ansible_user       = "ubuntu"
        ansible_become     = true
        validate_hosts = false
        kafka_broker_custom_properties = {
          "reserved.broker.max.id" = 10000
        }
        zookeeper_custom_properties = {
          "4lw.commands.whitelist" = "*"
        }
      }
    },
    

    zookeeper = {
      children = {
        "zookeeper_rack_a": null,
        "zookeeper_rack_b": null,
        "zookeeper_rack_c": null,
      }
    },
    zookeeper_rack_a = {
      vars = {},
      hosts = {
        for zookeeper in aws_instance.zk_closed_a:
          zookeeper.private_dns => {
            zookeeper_id = tonumber(join("", slice(split(".", zookeeper.private_ip), 2, 4))),
          }
      }
    },
    zookeeper_rack_b = {
      vars = {},
      hosts = {
        for zookeeper in aws_instance.zk_closed_b:
          zookeeper.private_dns => {
            zookeeper_id = tonumber(join("", slice(split(".", zookeeper.private_ip), 2, 4))),
          }
      }
    },
    zookeeper_rack_c = {
      vars = {},
      hosts = {
        for zookeeper in aws_instance.zk_closed_c:
          zookeeper.private_dns => {
            zookeeper_id = tonumber(join("", slice(split(".", zookeeper.private_ip), 2, 4))),
          }
      }
    },

    kafka_broker = {
      children = {
        "kafka_broker_rack_a": null,
        "kafka_broker_rack_b": null,
        "kafka_broker_rack_c": null,
      },
      vars = {}
    },
    kafka_broker_rack_a = {
      vars = {
        kafka_broker_custom_properties = {
          "broker.rack" = var.zonal_broker_rack ? "rack-${var.zones[0]}" : null
        }
      },
      hosts = {
        for broker in aws_instance.kafka_closed_a:
          broker.private_dns => {
            broker_id = tonumber(join("", slice(split(".", broker.private_ip), 2, 4))),
          }
      }
    },
    kafka_broker_rack_b = {
      vars = {
        kafka_broker_custom_properties = {
          "broker.rack" = var.zonal_broker_rack ? "rack-${var.zones[1]}" : null
        }
      },
      hosts = {
        for broker in aws_instance.kafka_closed_b:
          broker.private_dns => {
            broker_id = tonumber(join("", slice(split(".", broker.private_ip), 2, 4))),
          }
      }
    },
    kafka_broker_rack_c = {
      vars = {
        kafka_broker_custom_properties = {
          "broker.rack" = var.zonal_broker_rack ? "rack-${var.zones[2]}" : null
        }
      },
      hosts = {
        for broker in aws_instance.kafka_closed_c:
          broker.private_dns => {
            broker_id = tonumber(join("", slice(split(".", broker.private_ip), 2, 4))),
          }
      }
    },
  }
}