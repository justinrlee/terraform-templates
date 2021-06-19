output inventory {
  value = {
    all = {
      vars = {
        ansible_connection = "ssh"
        ansible_user = "ubuntu"
        ansible_become = true
        ssl_enabled = true
        validate_hosts = false
        regenerate_ca = false
      }
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
            for i in range(length(aws_instance.brokers_r0s.*.private_dns)): {
              broker_id: i + 100
            }
          ]
        ),

        zipmap(
          aws_instance.brokers_r1s.*.private_dns, [
            for i in range(length(aws_instance.brokers_r1s.*.private_dns)): {
              broker_id: i + 200
            }
          ]
        ),

        zipmap(
          aws_instance.brokers_r2s.*.private_dns, [
            for i in range(length(aws_instance.brokers_r2s.*.private_dns)): {
              broker_id: i + 300
            }
          ]
        )
      )
    }
  }   
}