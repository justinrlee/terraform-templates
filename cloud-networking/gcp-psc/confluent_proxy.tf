# GKE cluster to run proxy layer (could potentially be converted to autopilot)
resource "google_container_cluster" "proxy" {
  for_each = var.regions

  name     = "${var.environment_name}-${each.key}-proxy"
  location = each.key

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet[each.key].id

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

# Static IP for proxy load balancer
resource "google_compute_address" "proxy" {
  for_each = var.regions

  name = "${var.environment_name}-${each.key}-proxy-ip"

  region = each.key

  address_type = "EXTERNAL"
}

# module "gke_proxy" {
#   source = "./modules/gke_proxy"

#   for_each = var.regions

#   region = each.key
#   cluster_name = google_container_cluster.proxy[each.key].name
#   static_ip = google_compute_address.proxy[each.key].address
# }