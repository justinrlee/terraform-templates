data "google_compute_network" "vpc" {
  name = var.google_compute_network_name
}

# Only used if this TF owns the subnetwork; it's more likely that we're using existing subnetworks
# resource "google_compute_subnetwork" "subnet" {
#   name          = "${var.environment_name}-${var.region}"
#   ip_cidr_range = var.cidr
#   region        = var.region
#   network       = data.google_compute_network.vpc.id
# }

data "google_compute_subnetwork" "subnet" {
  region  = var.region
  project = var.google_project
  name    = var.google_compute_subnetwork_name
}