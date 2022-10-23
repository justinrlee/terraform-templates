locals {
  dns_domain                                  = confluent_network.network.dns_domain
  private_service_connect_service_attachments = confluent_network.network.gcp[0].private_service_connect_service_attachments
  network_id                                  = regex("^([^.]+)[.].*", local.dns_domain)[0]
}

# # Do this for each of three zones, across all regions (mux across regions, not zones)
resource "google_compute_address" "psc_endpoint_ip" {
  for_each = toset(var.zones)

  name         = "${var.environment_name}-ccloud-endpoint-${each.key}-${local.network_id}"
  subnetwork   = data.google_compute_subnetwork.subnet.id
  region       = var.region
  address_type = "INTERNAL"
}

# Private Service Connect endpoint
resource "google_compute_forwarding_rule" "psc_endpoint_ilb" {
  for_each = toset(var.zones)

  name = "${var.environment_name}-ccloud-endpoint-${each.key}-${local.network_id}"

  target                = local.private_service_connect_service_attachments[each.key]
  load_balancing_scheme = "" # need to override EXTERNAL default when target is a service attachment
  network               = data.google_compute_network.vpc.id
  region                = var.region
  ip_address            = google_compute_address.psc_endpoint_ip[each.key].id
}

# Firewall
resource "google_compute_firewall" "allow_https_kafka" {
  name    = "${var.environment_name}-ccloud-firewall-${local.network_id}"
  network = data.google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["443", "9092"]
  }

  direction          = "EGRESS"
  destination_ranges = [data.google_compute_subnetwork.subnet.ip_cidr_range]
}