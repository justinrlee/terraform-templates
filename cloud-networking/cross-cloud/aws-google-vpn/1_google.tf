
# 1x gcloud compute vpn-gateways
# 1x gcloud compute routers

resource "google_compute_ha_vpn_gateway" "gwy" {
  name    = "${var.prefix}-ha-vpn-gwy"
  network = var.google_network
  region  = var.google_region
}

resource "google_compute_router" "router" {
  name    = "${var.prefix}-router"
  network = var.google_network
  region  = var.google_region
  bgp {
    asn            = var.google_asn
    advertise_mode = "CUSTOM"
    advertised_groups = [
      "ALL_SUBNETS"
    ]
  }
}

output "google_outside_ip_addresses" {
  value = google_compute_ha_vpn_gateway.gwy.vpn_interfaces[*].ip_address
}