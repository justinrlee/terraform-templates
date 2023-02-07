terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
    }
  }
}

locals {
  tags = {
      "tf_owner"         = var.owner
      "tf_owner_contact" = var.owner
      "tf_provenance"    = "github.com/justinrlee/terraform-templates/cloud-networking/aws-privatelink-cross-region"
      "tf_workspace"     = terraform.workspace
      "tf_last_modified" = var.date_updated
      "Owner"            = var.owner
      "Environment"      = var.environment_name
      "owner_email"      = var.owner_email
    }

  ignore_tax_prefixes = [
    "divvy",
    "confluent-infosec",
    "ics"
  ]
}

provider "aws" {
  region = var.r1.region
  alias = "r1"

  ignore_tags {
    key_prefixes = local.ignore_tax_prefixes
  }

  default_tags {
    tags = local.tags
  }
}

provider "aws" {
  region = var.r2.region
  alias = "r2"

  ignore_tags {
    key_prefixes = local.ignore_tax_prefixes
  }

  default_tags {
    tags = local.tags
  }
}

data "aws_caller_identity" "r1" {
  provider = aws.r1
}

data "aws_caller_identity" "r2" {
  provider = aws.r2
}

# Could use a single provider instance, but using two for consistency with AWS
provider "confluent" {
  alias = "r1"
}

provider "confluent" {
  alias = "r2"
}