# Do this for each of three zones, across all regions (mux across regions, not zones)
resource "google_compute_address" "psc_0" {
  for_each = var.regions

  name = "${var.environment_name}-${each.key}-ip-0"
  subnetwork   = google_compute_subnetwork.subnet[each.key].id
  region = each.key
  address_type = "INTERNAL"
}

resource "google_compute_address" "psc_1" {
  for_each = var.regions

  name = "${var.environment_name}-${each.key}-ip-1"
  subnetwork   = google_compute_subnetwork.subnet[each.key].id
  region = each.key
  address_type = "INTERNAL"
}

resource "google_compute_address" "psc_2" {
  for_each = var.regions

  name = "${var.environment_name}-${each.key}-ip-2"
  subnetwork   = google_compute_subnetwork.subnet[each.key].id
  region = each.key
  address_type = "INTERNAL"
}

# Private Service Connect endpoint
resource "google_compute_forwarding_rule" "psc_endpoint_ilb_0" {
  for_each = var.regions

  name = "${var.environment_name}-ccloud-${each.key}-ip-0"

  target                = lookup(confluent_network.network[each.key].gcp[0].private_service_connect_service_attachments, each.value.zones[0], "\n\nerror: ${each.value.zones[0]} subnet is missing from CCN's Private Service Connect service attachments")
  load_balancing_scheme = "" # need to override EXTERNAL default when target is a service attachment
  network               = google_compute_network.vpc.id
  # subnetwork            = google_compute_subnetwork.subnet[each.key].id
  region                = each.key
  ip_address            = google_compute_address.psc_0[each.key].id
}
resource "google_compute_forwarding_rule" "psc_endpoint_ilb_2" {
  for_each = var.regions

  name = "${var.environment_name}-ccloud-${each.key}-ip-1"

  target                = lookup(confluent_network.network[each.key].gcp[0].private_service_connect_service_attachments, each.value.zones[1], "\n\nerror: ${each.value.zones[1]} subnet is missing from CCN's Private Service Connect service attachments")
  load_balancing_scheme = "" # need to override EXTERNAL default when target is a service attachment
  network               = google_compute_network.vpc.id
  # subnetwork            = google_compute_subnetwork.subnet[each.key].id
  region                = each.key
  ip_address            = google_compute_address.psc_1[each.key].id
}
resource "google_compute_forwarding_rule" "psc_endpoint_ilb_1" {
  for_each = var.regions

  name = "${var.environment_name}-ccloud-${each.key}-ip-2"

  target                = lookup(confluent_network.network[each.key].gcp[0].private_service_connect_service_attachments, each.value.zones[2], "\n\nerror: ${each.value.zones[2]} subnet is missing from CCN's Private Service Connect service attachments")
  load_balancing_scheme = "" # need to override EXTERNAL default when target is a service attachment
  network               = google_compute_network.vpc.id
  # subnetwork            = google_compute_subnetwork.subnet[each.key].id
  region                = each.key
  ip_address            = google_compute_address.psc_2[each.key].id
}

resource "google_compute_firewall" "allow-https-kafka" {
  for_each = var.regions
  name    = "${var.environment_name}-ccloud-firewall-${each.key}"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "9092"]
  }

  direction          = "EGRESS"
  destination_ranges = [google_compute_subnetwork.subnet[each.key].ip_cidr_range]
}