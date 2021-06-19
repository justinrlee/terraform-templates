provider "aws" {
  # region = "us-east-1"
  region = var.r1
  alias  = "r1a"
}

provider "aws" {
  # region = "us-east-2"
  region = var.r2
  alias  = "r2a"
}

provider "aws" {
  # region = "us-west-2"
  region = var.r3
  alias  = "r3a"
}