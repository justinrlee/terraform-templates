
# Comes from parent
data "confluent_environment" "confluent_environment" {
  id = var.confluent_environment_id
}

resource "confluent_network" "network" {
  display_name     = "${var.region}-psc"
  cloud            = "GCP"
  region           = var.region
  connection_types = ["PRIVATELINK"]

  zones = var.zones

  environment {
    id = data.confluent_environment.confluent_environment.id
  }

  lifecycle {
    # prevent_destroy = true
  }
}


resource "confluent_private_link_access" "gcp" {
  display_name = "GCP Private Service Connect"

  gcp {
    project = var.google_project
  }
  environment {
    id = data.confluent_environment.confluent_environment.id
  }
  network {
    id = confluent_network.network.id
  }

  lifecycle {
    # prevent_destroy = true
  }
}