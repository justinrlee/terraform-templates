locals {
  sshkey = file("~/.ssh/id_rsa.pub")
}

# Firewall
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.environment_name}-ssh"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "default" {
  for_each = var.regions

  name         = "${var.environment_name}-${each.key}"
  machine_type = "e2-medium"
  zone         = each.value.zones[0]

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet[each.key].name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    "ssh-keys" : "ubuntu:${local.sshkey}"
  }

  depends_on = [
    google_compute_subnetwork.subnet
  ]
}