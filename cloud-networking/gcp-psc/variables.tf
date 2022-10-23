variable "environment_name" {
  type = string
  validation {
    condition     = can(regex("[a-z]([-a-z0-9]*[a-z0-9])?", var.environment_name))
    error_message = "Invalid environment_name; must start with lowercase letter, and all following characters must be a dash, lowercase letter, or digit."
  }
}

variable "regions" {}
variable "google_project" {}
variable "owner" {}

variable "internal_proxy" {
  default = true
}
variable "external_proxy" {
  default = false
}
variable "external_proxy_whitelist" {
  default = "0.0.0.0/0"
}