output "external_proxy_endpoint" {
  value = var.external ? google_compute_address.external_proxy[0].address : null
}

output "internal_proxy_endpoint" {
  value = var.internal ? google_compute_address.internal_proxy[0].address : null
}

output "kafka_endpoint" {
  value = var.dedicated_cluster ? confluent_kafka_cluster.dedicated[0].bootstrap_endpoint : null
}

// TODO: Output cluster info