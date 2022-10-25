# Static External IP for proxy load balancer
resource "google_compute_address" "external_proxy" {
  count = var.external ? 1 : 0

  name = "${var.environment_name}-${var.region}-proxy-ip"

  region = var.region

  address_type = "EXTERNAL"
}

resource "google_compute_address" "internal_proxy" {
  count = var.internal ? 1 : 0
  name  = "${var.environment_name}-${var.region}-internal-proxy-ip"

  subnetwork = var.google_compute_subnetwork_name

  region       = var.region
  address_type = "INTERNAL"
}
