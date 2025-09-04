# variable r2_region {
#   default = "us-west-2"
# }

variable "r1_zones" {
  default = [
    "use1-az1",
    "use1-az2",
    "use1-az5",
  ]
}

variable "r2_zones" {
  default = [
    "usw2-az1",
    "usw2-az2",
    "usw2-az3",
  ]
}

variable "r1" {
  default = {
    region = "us-east-1"
    cidr   = "10.1.0.0/16"
    zone = "use1-az1"
    zones = {
      "use1-az1" = {
        public_subnet  = "10.1.1.0/24",
        private_subnet = "10.1.11.0/24",
      }
      "use1-az2" = {
        public_subnet  = "10.1.2.0/24",
        private_subnet = "10.1.12.0/24",
      }
      "use1-az5" = {
        public_subnet  = "10.1.5.0/24",
        private_subnet = "10.1.15.0/24",
      }
    }
  }
}

variable "r2" {
  default = {
    region = "us-west-2"
    cidr   = "10.2.0.0/16"
    # azs are pulled from r1_zones
    zone = "usw2-az1"
    zones = {
      "usw2-az1" = {
        public_subnet  = "10.2.1.0/24",
        private_subnet = "10.2.11.0/24",
      }
      "usw2-az2" = {
        public_subnet  = "10.2.2.0/24",
        private_subnet = "10.2.12.0/24",
      }
      "usw2-az3" = {
        public_subnet  = "10.2.3.0/24",
        private_subnet = "10.2.13.0/24",
      }
    }
  }
}

variable "r1_topic" {
  default = "use1-raw"
}

variable "r2_topic" {
  default = "usw2-raw"
}

variable "date_updated" {}

variable "owner" {}
variable "owner_email" {}

variable "environment_name" {}

variable "eks_version" {
  default = "1.24"
}

variable "aws_amis" {
  default = {
    "us-east-1" = "ami-01d08089481510ba2",
    "us-east-2" = "ami-0066d036f9777ec38",
    "us-west-1" = "ami-064562725417500be",
    "us-west-2" = "ami-0e6dff8bde9a09539",
  }
}