output "external_proxy_endpoint" {
  value = var.external_proxy ? google_compute_address.external_proxy[0].address : null
}

output "internal_proxy_endpoint" {
  value = var.internal_proxy ? google_compute_address.internal_proxy[0].address : null
}

output "kafka_endpoint" {
  value = var.dedicated_cluster ? confluent_kafka_cluster.dedicated[0].bootstrap_endpoint : null
}

output "external_dns_endpoint" {
  value = var.external_dns ? google_compute_address.external_coredns[0].address: null
}

output "external_whitelist" {
  value = var.external_proxy_whitelist
}

// TODO: Output cluster info