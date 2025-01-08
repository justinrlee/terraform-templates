locals {
  brokers = {
    for nlb in [
        "az1",
        "az2",
        "az3",
      ]:
      nlb => range(var.zone_broker_offsets[nlb], var.zone_broker_offsets[nlb] + var.brokers_per_nlb * 3, 3)
  }
      
  bootstrap_server_mappings = sort(flatten([
    for nlb,brokers in local.brokers:
      [
        for broker in brokers: 
          "    --bootstrap-server-mapping \"b${broker}-${var.bootstrap_server},0.0.0.0:${var.port_broker_start + broker},${var.proxy_endpoints[nlb]}.${var.proxy_dns_zone}:${var.port_broker_start + broker}\""
      ]
  ]))

  start_command = join(" \\\n",
    concat(
    [
      "/usr/local/bin/kafka-proxy server",
      "    --tls-enable",
      "    --bootstrap-server-mapping \"${var.bootstrap_server},0.0.0.0:9092,${var.proxy_bootstrap}.${var.proxy_dns_zone}:9092\""
    ]
    ,local.bootstrap_server_mappings
    )
  )

  start_command_b64gzip = base64gzip(local.start_command)

  userdata = <<-EOT
  #!/bin/bash
  
  curl -Ls https://github.com/grepplabs/kafka-proxy/releases/download/v0.3.11/kafka-proxy-v0.3.11-linux-amd64.tar.gz | tar xz -C /usr/local/bin/

  echo '${local.start_command_b64gzip}' | base64 -d | gunzip > /tmp/start-kafka-proxy.sh

  chmod +x /tmp/start-kafka-proxy.sh
  /tmp/start-kafka-proxy.sh
  sleep 5

  ss -plunt
  EOT
}

output "command" {
  value = join(" \\\n",
    concat(
    [
      "./kafka-proxy server",
      "    --tls-enable",
      "    --bootstrap-server-mapping \"${var.bootstrap_server},0.0.0.0:9092,${var.proxy_bootstrap}.${var.proxy_dns_zone}:9092\""
    ]
    ,local.bootstrap_server_mappings
    )
  )
}

output "userdata" {
  value = local.userdata
}