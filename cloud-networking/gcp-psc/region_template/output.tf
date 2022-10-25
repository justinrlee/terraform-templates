output "external_proxy_endpoint" {
  value = var.external ? google_compute_address.external_proxy[0].address : null
}

output "internal_proxy_endpoint" {
  value = var.internal ? google_compute_address.internal_proxy[0].address : null
}

// TODO: Output cluster info