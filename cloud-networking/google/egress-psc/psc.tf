
# # Private Service Connect Subnet
resource "google_compute_subnetwork" "psc" {
  name          = "${var.prefix}-psc-subnet"
  ip_cidr_range = var.psc_subnet_cidr
  region        = var.google_region
  network       = var.google_network
  purpose       = "PRIVATE_SERVICE_CONNECT"
}

# Service Attachment for Private Service Connect
resource "google_compute_service_attachment" "main" {
  name   = "${var.prefix}-psc-sa"
  region = var.google_region
  
  target_service          = google_compute_forwarding_rule.main.id
  connection_preference   = "ACCEPT_MANUAL"
  nat_subnets            = [google_compute_subnetwork.psc.id]
  enable_proxy_protocol   = false
}
