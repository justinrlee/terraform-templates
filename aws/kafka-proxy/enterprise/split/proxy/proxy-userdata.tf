locals {
#   brokers = {
#     for nlb in [
#         "az1",
#         "az2",
#         "az3",
#       ]:
#       nlb => range(var.zone_broker_offsets[nlb], var.zone_broker_offsets[nlb] + var.brokers_per_nlb * 3, 3)
#   }
      
#   bootstrap_server_mappings = sort(flatten([
#     for nlb,brokers in local.brokers:
#       [
#         for broker in brokers: 
#           "    --bootstrap-server-mapping \"b${broker}-${var.bootstrap_server},0.0.0.0:${var.port_broker_start + broker},${var.proxy_endpoints[nlb]}.${var.route_53_domain}:${var.port_broker_start + broker}\""
#       ]
#   ]))

  start_command = join(" \\\n",
    concat(
        [
        "nohup",
        "/usr/local/bin/kafka-proxy server",
        "    --tls-enable",
        "    --dynamic-advertised-listener ${var.proxy_bootstrap}.${var.route_53_domain}",
        "    --dynamic-sequential-min-port 10000",
        "    --deterministic-listeners",
        "    --bootstrap-server-mapping \"${var.bootstrap_server},0.0.0.0:9092,${var.proxy_bootstrap}.${var.route_53_domain}:9092\"",
        "    2>> /var/log/kafka-proxy/err.log",
        "    >> /var/log/kafka-proxy/out.log",
        ]
    )
  )

  start_command_b64gzip = base64gzip(local.start_command)

  userdata = <<-EOT
  #!/bin/bash
  
  curl -Ls https://github.com/justinrlee/kafka-proxy/releases/download/v0.3.14-dl/kafka-proxy-v0.3.14-dl-linux-amd64.tar.gz | tar xz -C /usr/local/bin/

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