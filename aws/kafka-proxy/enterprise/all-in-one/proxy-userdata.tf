locals {
  start_command = join(" \\\n",
    concat(
        [
        "nohup",
        "/usr/local/bin/kafka-proxy server",
        "    --tls-enable",
        "    --dynamic-advertised-listener ${local.proxy_kafka_endpoint}",
        "    --dynamic-sequential-min-port 10000",
        "    --deterministic-listeners",
        "    --bootstrap-server-mapping \"${confluent_kafka_cluster.main.bootstrap_endpoint},0.0.0.0:9092,${local.proxy_kafka_endpoint}:9092\"",
        "    2>> /var/log/kafka-proxy/err.log",
        "    >> /var/log/kafka-proxy/out.log",
        ]
    )
  )

  start_command_b64gzip = base64gzip(local.start_command)

  userdata = <<-EOT
  #!/bin/bash
  
  curl -Ls ${var.proxy_tarball} | tar xz -C /usr/local/bin/

  echo '${local.start_command_b64gzip}' | base64 -d | gunzip > /tmp/start-kafka-proxy.sh

  mkdir /var/log/kafka-proxy
  chmod +x /tmp/start-kafka-proxy.sh
  /tmp/start-kafka-proxy.sh
  sleep 5

  ss -plunt
  EOT
}

output "command" {
  value = local.start_command
}

output "userdata" {
  value = local.userdata
}