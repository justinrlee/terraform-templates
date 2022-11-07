variable "environment_name" {
  type = string
  validation {
    condition     = can(regex("[a-z]([-a-z0-9]*[a-z0-9])?", var.environment_name))
    error_message = "Invalid environment_name; must start with lowercase letter, and all following characters must be a dash, lowercase letter, or digit."
  }
}

variable "namespace" {
  default = "confluent-proxy"
}

variable "region" {}
variable "google_project" {}
variable "owner" {}
variable "zones" {}
variable "google_compute_network_name" {}
variable "google_compute_subnetwork_name" {}
variable "confluent_environment_id" {}

# Can create internal, external, or both proxies
variable "external_proxy" {
  default = false
}

variable "external_dns" {
  default = false
}

variable "internal_proxy" {
  default = true
}

variable "external_proxy_whitelist" {
  default = "0.0.0.0/0"
}

# Toggles to disable certain capabilities

variable "dedicated_cluster" {
  default = true
}

variable "dedicated_ckus" {
  default = 1
}

variable "dedicated_maz" {
  default = false
}

# Workaround for lack of assertion in TF < 1.2
resource "null_resource" "maz_2_cku" {
  count = (var.dedicated_cluster && var.dedicated_maz && var.dedicated_ckus < 2) ? "ERROR: Multi-AZ clusters need at least 2 CKUs" : 0
}



// TODO: make flaggable:
// CCN (proxy for peering instead)
// Remote regions