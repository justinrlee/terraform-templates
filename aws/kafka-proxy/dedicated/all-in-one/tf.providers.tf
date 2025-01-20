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
      "tf_owner"         = var.owner_name
      "tf_owner_contact" = var.owner_contact
      "tf_provenance"    = "github.com/justinrlee/terraform-templates/aws/kafka-proxy"
      "tf_workspace"     = terraform.workspace
      "tf_last_modified" = var.date_updated
      "Owner"            = var.owner_name
      "Environment"      = var.environment_name
      "owner_email"      = var.owner_contact
    }
  }
}