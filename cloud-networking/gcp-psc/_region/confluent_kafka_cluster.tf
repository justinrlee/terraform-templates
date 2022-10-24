resource "confluent_kafka_cluster" "dedicated" {

  display_name = "${var.environment_name}-${var.region}-dedicated"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = var.region

  dedicated {
    cku = 1
  }
  environment {
    id = data.confluent_environment.confluent_environment.id
  }
  network {
    id = confluent_network.network.id
  }
}