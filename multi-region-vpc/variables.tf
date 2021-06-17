# Global

variable "instance_type" {
    type = string
    default = "m5.xlarge"
}

variable "cluster_name" {
    type = string
    default = "justin-mrc"
}

variable "owner_name" {
    type = string
    default = "Justin Lee"
}

# Region-specific
variable "use1_slash16" {
    type = string
    default = "10.2"
}

variable "use2_slash16" {
    type = string
    default = "10.18"
}

variable "usw2_slash16" {
    type = string
    default = "10.50"
}
