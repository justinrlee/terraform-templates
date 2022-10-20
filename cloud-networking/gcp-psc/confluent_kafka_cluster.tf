resource "confluent_kafka_cluster" "dedicated" {
  for_each = var.regions

  display_name = "${each.key}"
  availability = "SINGLE_ZONE"
  cloud        = "GCP"
  region       = each.key
  
  dedicated {
    cku = 1
  }
  environment {
    id = confluent_environment.demo.id
  }
  network {
    id = confluent_network.network[each.key].id
  }
}