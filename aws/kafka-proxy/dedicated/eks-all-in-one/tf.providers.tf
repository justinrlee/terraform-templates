terraform {
  backend "s3" {
    bucket = "justin-confluent-apse1"
    key    = "ap-southeast-1/kafka-proxy/dedicated/eks-all-in-one"
    # bucket region, not resource region
    region = "ap-southeast-1"
  }

  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.12.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.83.0"
    }
    http = {
      source = "hashicorp/http"
      version = "3.4.5"
    }
  }
}

provider "confluent" {

}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "Owner"            = var.owner_name
      # "Environment"      = var.environment_name
      "environment"      = var.environment_name
      "owner_email"      = var.owner_contact
      "tf_provenance"    = "github.com/justinrlee/terraform-templates/aws/kafka-proxy/dedicated/eks-all-in-one"
      "tf_owner"         = var.owner_name
      "tf_owner_contact" = var.owner_contact
      "tf_workspace"     = terraform.workspace
      "tf_last_modified" = var.date_updated
    }
  }

  ignore_tags {
    key_prefixes = [
      "divvy",
    ]
  }
}