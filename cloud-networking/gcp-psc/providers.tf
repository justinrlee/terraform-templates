terraform {
  required_providers {
    confluent = {
      source = "confluentinc/confluent"
      version = "1.8.0"
    }
  }
}

provider "google" {
  project = var.google_project
}

provider "confluent" {
  # Sourced from /Users/jlee/git/justinrlee/private-terraform/ccloud/strategic/creds:
  # * CONFLUENT_CLOUD_API_KEY
  # cloud_api_key    = var.confluent_cloud_api_key
  # * CONFLUENT_CLOUD_API_SECRET
  # cloud_api_secret = var.confluent_cloud_api_secret
}

# I think this is global
data "google_client_config" "provider" {}