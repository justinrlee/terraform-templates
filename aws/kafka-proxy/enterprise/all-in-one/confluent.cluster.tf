
resource "confluent_kafka_cluster" "main" {
  display_name = var.environment_name
  availability = "HIGH"
  cloud        = "AWS"
  region       = var.region
  enterprise {}

  environment {
    id = confluent_environment.main.id
  }

}
