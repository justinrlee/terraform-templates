resource "confluent_environment" "demo" {
  display_name = var.environment_name
}

# Inserting a local here makes it easier to swap out a variable for a terraform resource property
locals {
  confluent_environment_id = confluent_environment.demo.id
}
