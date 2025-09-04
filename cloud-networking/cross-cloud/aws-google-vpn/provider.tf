terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    google = {
        source = "hashicorp/google"
        version = "~> 7.0"
    }
  }
}

provider "google" {
    project = var.google_project_id
}