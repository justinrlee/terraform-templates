terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.8.0"
    }
  }
}

provider "aws" {
  region = var.region

  ignore_tags {
    key_prefixes = [
      "divvy",
      "confluent-infosec",
      "ics"
    ]
  }

  default_tags {
    tags = {
      "tf_owner"         = var.owner
      "tf_owner_contact" = var.owner
      "tf_provenance"    = "github.com/justinrlee/terraform-templates/cloud-networking/aws-privatelink"
      "tf_workspace"     = terraform.workspace
      "tf_last_modified" = "NA"
      "Owner"            = var.owner
      "Environment"      = var.environment_name
      "owner_email"      = var.owner_email
    }
  }
}

provider "confluent" {
  # Sourced from /Users/jlee/git/justinrlee/private-terraform/ccloud/strategic/creds:
  # * CONFLUENT_CLOUD_API_KEY
  # cloud_api_key    = var.confluent_cloud_api_key
  # * CONFLUENT_CLOUD_API_SECRET
  # cloud_api_secret = var.confluent_cloud_api_secret
}