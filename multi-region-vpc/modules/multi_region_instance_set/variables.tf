variable instance_counts {
    default = [2, 2, 0]
}

variable regions {
  default = ["us-east-1", "us-east-2", "us-west-2"]
}

variable "aws_amis" {
  default = {
    # Ubuntu 20.04
    # "us-east-1"      = "ami-0c536cd6abac1a385"
    # "us-east-2"      = "ami-06382629a9eb569e3"
    # "us-west-1"      = "ami-0a1a90c77c33d81f9"
    # "us-west-2"      = "ami-0a1b477074e2f1708"

    # Ubuntu 18.04
    "us-east-1"      = "ami-0e4d932065378fd3d"
    "us-east-2"      = "ami-063e88ad6c9af427d"
    "us-west-1"      = "ami-05620e35978c63272"
    "us-west-2"      = "ami-0b7d93899b51ff83b"
  }
}

variable instance_type {
  default = "t3.large"
}

variable public_ip {
  default = false
}

variable public_subnet {
  default = false
}

variable ec2_public_key_names {
}

variable public_subnets {
# list of lists
}

variable private_subnets {
# list of lists
}

variable public_security_groups {
}

variable private_security_groups {
}

variable delete_root_block_device_on_termination {
  default = true
}

variable cluster_name {
}

variable type {
}

variable label {
}