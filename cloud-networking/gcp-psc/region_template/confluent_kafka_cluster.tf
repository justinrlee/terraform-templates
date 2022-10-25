resource "confluent_kafka_cluster" "dedicated" {
  count = var.dedicated_cluster ? 1 : 0

  display_name = "${var.environment_name}-${var.region}-dedicated"
  availability = var.dedicated_maz ? "MULTI_ZONE" : "SINGLE_ZONE"
  cloud        = "GCP"
  region       = var.region

  dedicated {
    cku = var.dedicated_ckus
  }
  environment {
    id = data.confluent_environment.confluent_environment.id
  }
  network {
    id = confluent_network.network.id
  }
}