provider "aws" {
  # region = "us-east-1"
  region = var.regions[0]
  alias  = "r0a"
}

# provider "aws" {
#   # region = "us-east-2"
#   region = var.regions[1]
#   alias  = "r1a"
# }

# provider "aws" {
#   # region = "us-west-2"
#   region = var.regions[2]
#   alias  = "r2a"
# }