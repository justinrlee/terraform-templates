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
variable "external" {
  default = false
}

variable "internal" {
  default = true
}