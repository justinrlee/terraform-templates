terraform {
  backend "s3" {
    bucket = "cc-poc-nexon-terraform"
    key    = "us-west-2/dedicated"
    # bucket region, not resource region
    region = "ap-northeast-2"
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
      "tf_provenance"    = "github.com/justinrlee/nexon-pocus/us-west-2/dedicated"
      "environment"      = var.environment_name
    }
  }

  ignore_tags {
    key_prefixes = [
      "nx",
    ]
  }
}