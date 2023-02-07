resource "confluent_environment" "r2" {
  display_name = "${var.environment_name}-${var.r2.region}"
  
  provider = confluent.r2
}

resource "confluent_network" "r2" {
  display_name     = "aws-privatelink-${var.r2.region}"
  cloud            = "AWS"
  region           = var.r2.region
  connection_types = ["PRIVATELINK"]
  dns_config {
    resolution = "PRIVATE"
  }

  zones = keys(var.r2.zones)

  environment {
    id = confluent_environment.r2.id
  }

  lifecycle {
    # prevent_destroy = true
  }

  provider = confluent.r2
}

resource "confluent_private_link_access" "r2" {
  display_name = data.aws_caller_identity.r2.account_id

  aws {
    account = data.aws_caller_identity.r2.account_id
  }
  environment {
    id = confluent_environment.r2.id
  }
  network {
    id = confluent_network.r2.id
  }

  lifecycle {
    # prevent_destroy = true
  }

  provider = confluent.r2
}