resource "confluent_kafka_cluster" "r2" {
  # count = var.dedicated_cluster ? 1 : 0

  display_name = "${var.environment_name}-${var.r2.region}-dedicated"
  # availability = var.dedicated_maz ? "MULTI_ZONE" : "SINGLE_ZONE"
  availability = "MULTI_ZONE"
  cloud        = "AWS"
  region       = var.r2.region

  dedicated {
    cku = 2
    # cku = var.dedicated_ckus
  }
  environment {
    id = confluent_environment.r2.id
  }
  network {
    id = confluent_network.r2.id
  }

  provider = confluent.r2
}

output "r2_bootstrap" {
  value = confluent_kafka_cluster.r2.bootstrap_endpoint
}