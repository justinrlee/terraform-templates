resource "confluent_environment" "r1" {
  display_name = "${var.environment_name}-${var.r1.region}"

  provider = confluent.r1
}

resource "confluent_network" "r1" {
  display_name     = "aws-privatelink-${var.r1.region}"
  cloud            = "AWS"
  region           = var.r1.region
  connection_types = ["PRIVATELINK"]
  dns_config {
    resolution = "PRIVATE"
  }

  zones = keys(var.r1.zones)

  environment {
    id = confluent_environment.r1.id
  }

  lifecycle {
    # prevent_destroy = true
  }

  provider = confluent.r1
}

resource "confluent_private_link_access" "r1" {
  display_name = data.aws_caller_identity.r1.account_id

  aws {
    account = data.aws_caller_identity.r1.account_id
  }
  environment {
    id = confluent_environment.r1.id
  }
  network {
    id = confluent_network.r1.id
  }

  lifecycle {
    # prevent_destroy = true
  }

  provider = confluent.r1
}