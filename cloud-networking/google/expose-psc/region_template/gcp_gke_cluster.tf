# GKE cluster to run proxy layer (could potentially be converted to autopilot)
resource "google_container_cluster" "proxy" {
  name     = "${var.environment_name}-${var.region}-proxy"
  location = var.region

  network    = data.google_compute_network.vpc.id
  subnetwork = data.google_compute_subnetwork.subnet.id

  initial_node_count = 1
  node_config {
    labels = {
      owner = var.owner
    }
    tags = ["test"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}