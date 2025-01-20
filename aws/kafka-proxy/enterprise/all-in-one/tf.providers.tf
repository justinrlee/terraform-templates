terraform {
  backend "s3" {
    bucket = "justin-confluent-terraform-apse1"
    key    = "us-west-2/enterprise"
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
  }
}

provider "confluent" {

}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "tf_provenance"    = "github.com/justinrlee/terraform-templates/aws/kafka-proxy/enterprise/all-in-one"
      "run_location"     = "build/git/justinrlee"
      "environment"      = var.environment_name
    }
  }

  ignore_tags {
    key_prefixes = [
    ]
  }
}