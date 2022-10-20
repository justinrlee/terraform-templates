resource "confluent_environment" "demo" {
  display_name = var.environment_name  
  # provisioner "local-exec" {
  #   command = "confluent login"
  # }
}

resource "confluent_network" "network" {
  for_each = var.regions

  display_name     = "${each.key}-psc"
  cloud            = "GCP"
  region           = each.key

  connection_types = ["PRIVATELINK"]
  zones            = each.value.zones

  environment {
    id = confluent_environment.demo.id
  }

  lifecycle {
    prevent_destroy = true
  }
}


resource "confluent_private_link_access" "gcp" {
  for_each = var.regions

  display_name = "GCP Private Service Connect"

  gcp {
    project = var.google_project
  }
  environment {
    id = confluent_environment.demo.id
  }
  network {
    id = confluent_network.network[each.key].id
  }

  lifecycle {
    prevent_destroy = true
  }
}