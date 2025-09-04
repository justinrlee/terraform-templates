# resource "google_compute_subnetwork" "proxy" {
#   name          = "${var.prefix}-proxy"
#   ip_cidr_range = var.proxy_subnet_cidr
#   region        = var.google_region
#   network       = var.google_network

#   purpose = "REGIONAL_MANAGED_PROXY"
#   role    = "ACTIVE"
# }

resource "google_compute_network_endpoint_group" "main" {
  for_each = var.google_zones

  name    = "${var.prefix}-${each.key}"
  network = var.google_network
  zone    = each.key

  network_endpoint_type = "NON_GCP_PRIVATE_IP_PORT"
}

resource "google_compute_network_endpoint" "main" {
  for_each = var.google_zones

  network_endpoint_group = google_compute_network_endpoint_group.main[each.key].name

  ip_address = var.target_ip
  port       = var.target_port
  zone       = each.key
}

resource "google_compute_region_health_check" "main" {
  name   = var.prefix
  region = var.google_region

  tcp_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_region_backend_service" "main" {
  name                  = var.prefix
  load_balancing_scheme = "INTERNAL_MANAGED"
  protocol              = "TCP"
  region                = var.google_region

  health_checks = [google_compute_region_health_check.main.id]

  dynamic "backend" {
    for_each = var.google_zones
    content {
      group           = google_compute_network_endpoint_group.main[backend.key].id
      balancing_mode  = "CONNECTION"
      max_connections = 100
      # capacity_scaler must be set if load_balancing_scheme is not "INTERNAL"
      capacity_scaler = 1
    }
  }
}

resource "google_compute_region_target_tcp_proxy" "main" {
  name            = var.prefix
  region          = var.google_region
  backend_service = google_compute_region_backend_service.main.id
}

resource "google_compute_address" "load_balancer" {
  name = "${var.prefix}-lb"
  subnetwork = var.google_subnetwork
  address_type = "INTERNAL"
  address = var.load_balancer_ip
  region = var.google_region

}

resource "google_compute_forwarding_rule" "main" {
  name                  = var.prefix
  load_balancing_scheme = "INTERNAL_MANAGED"
  network               = var.google_network
  region                = var.google_region
  subnetwork            = var.google_subnetwork
  ip_protocol           = "TCP"
  port_range            = var.target_port
  ip_address            = google_compute_address.load_balancer.id
  target                = google_compute_region_target_tcp_proxy.main.id

  # depends_on = [ google_compute_subnetwork.proxy ]
}

output "load_balancer_ip" {
  value = var.load_balancer_ip
}