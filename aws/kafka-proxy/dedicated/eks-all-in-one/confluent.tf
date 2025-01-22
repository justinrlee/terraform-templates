resource "confluent_kafka_cluster" "main" {
  display_name = var.environment_name
  availability = "MULTI_ZONE"
  cloud        = "AWS"
  region       = var.region
  dedicated {
    cku = 2
  }
  environment {
    id = confluent_environment.main.id
  }
  network {
    id = confluent_network.peering.id
  }
}

locals {
  zone_broker_offsets = {
    for i,zone in confluent_kafka_cluster.main.dedicated[0].zones:
      split("-", zone)[1] => i
  }
}