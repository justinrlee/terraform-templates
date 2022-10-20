resource "google_compute_network" "vpc" {
  name                    = var.environment_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  for_each = var.regions
  
  name          = "${var.environment_name}-${each.key}"
  ip_cidr_range = each.value.cidr
  region        = each.key
  network       = google_compute_network.vpc.id
}