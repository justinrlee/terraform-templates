resource "google_compute_address" "external_coredns" {
  count = var.external_dns ? 1 : 0

  name = "${var.environment_name}-${var.region}-coredns-ip"

  region = var.region

  address_type = "EXTERNAL"
}