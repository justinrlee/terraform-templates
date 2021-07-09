# provider "aws" {
#   region = var.regions[0]
#   alias  = "r0a"
# }

# provider "aws" {
#   region = var.regions[1]
#   alias  = "r1a"
# }

# provider "aws" {
#   region = var.regions[2]
#   alias  = "r2a"
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
      configuration_aliases = [ aws.r0a, aws.r1a, aws.r2a ]
    }
  }
}