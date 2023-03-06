
resource "confluent_network" "network" {
  display_name     = "aws-privatelink-${var.region}"
  cloud            = "AWS"
  region           = var.region
  connection_types = ["PRIVATELINK"]

  zones = var.zones

  environment {
    id = local.confluent_environment_id
  }

  lifecycle {
    # prevent_destroy = true
  }
}

resource "confluent_private_link_access" "aws" {
  display_name = "AWS PrivateLink"

  aws {
    account = var.aws_account
  }
  environment {
    id = local.confluent_environment_id
  }
  network {
    id = confluent_network.network.id
  }

  lifecycle {
    # prevent_destroy = true
  }
}