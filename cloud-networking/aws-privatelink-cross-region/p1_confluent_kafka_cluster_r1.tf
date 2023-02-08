resource "confluent_kafka_cluster" "r1" {
  # count = var.dedicated_cluster ? 1 : 0

  display_name = "${var.environment_name}-${var.r1.region}-dedicated"
  # availability = var.dedicated_maz ? "MULTI_ZONE" : "SINGLE_ZONE"
  availability = "MULTI_ZONE"
  cloud        = "AWS"
  region       = var.r1.region

  dedicated {
    cku = 2
    # cku = var.dedicated_ckus
  }
  environment {
    id = confluent_environment.r1.id
  }
  network {
    id = confluent_network.r1.id
  }

  provider = confluent.r1
}

output "r1_bootstrap" {
  value = confluent_kafka_cluster.r1.bootstrap_endpoint
}