locals {
  ordered_zones = {
    for k,v in local.zone_broker_offsets:
      v => k
  }

  upstream = trimsuffix(trimprefix(confluent_kafka_cluster.main.bootstrap_endpoint,"SASL_SSL://"),":9092")

  jsonnet = templatefile("config/envoy.jsonnet.tftpl",{
    UPSTREAM = local.upstream,
    PROXY_ENDPOINT = local.proxy_kafka_endpoint,
    PROXY_0_ENDPOINT = local.proxy_zonal_endpoints[local.ordered_zones["0"]],
    PROXY_1_ENDPOINT = local.proxy_zonal_endpoints[local.ordered_zones["1"]],
    PROXY_2_ENDPOINT = local.proxy_zonal_endpoints[local.ordered_zones["2"]],
  } )

  jsonnet_b64gzip = base64gzip(local.jsonnet)

  start_command = join(" \\\n",
    concat(
    [
      "nohup",
      "/usr/local/bin/envoy",
      "    -c /etc/envoy.json",
      "    2>> /var/log/envoy/err.log",
      "    >> /var/log/envoy/out.log",
    ],
    )
  )

  start_command_b64gzip = base64gzip(local.start_command)

  userdata = <<-EOT
  #!/bin/bash

  apt-get update
  apt-get install -y jsonnet

  ulimit -n 262144

  curl -L https://github.com/envoyproxy/envoy/releases/download/v1.32.3/envoy-contrib-1.32.3-linux-x86_64 -o /usr/local/bin/envoy
  chmod +x /usr/local/bin/envoy

  echo '${local.jsonnet_b64gzip}' | base64 -d | gunzip > /tmp/envoy.jsonnet
  jsonnet /tmp/envoy.jsonnet > /etc/envoy.json
  echo '${local.start_command_b64gzip}' | base64 -d | gunzip > /tmp/start-envoy.sh

  mkdir /var/log/envoy
  chmod +x /tmp/start-envoy.sh
  /tmp/start-envoy.sh
  sleep 5

  ss -plunt
  EOT
}

output "start_command" {
  value = local.start_command
}

output "userdata" {
  value = local.userdata
}