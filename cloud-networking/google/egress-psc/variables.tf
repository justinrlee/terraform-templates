variable "create_proxy_subnet" {
  type    = bool
  default = true
}

variable "google_project_id" {
  type        = string
  description = "The ID of the project to use for the resources"
}

variable "google_region" {
  type = string
}

variable "google_zones" {
  type = map(any)
  # google_zones = {"asia-southeast1-a": {}, "asia-southeast1-b": {}}
}

variable "google_network" {
  type        = string
  description = "Name of the GCP network."
}

variable "google_subnetwork" {
  type        = string
  description = "Name of the GCP subnetwork."
}

variable "prefix" {
  type        = string
  description = "Prefix used for all the resources."
}

variable "proxy_subnet_cidr" {
  type = string
}

variable "load_balancer_ip" {
  type        = string
  description = "The IP address of the load balancer."
}

variable "target_ip" {
  type        = string
  description = "The IP address of the target server."
}

variable "target_port" {
  type        = number
  description = "The port of the target server."
}

variable "psc_subnet_cidr" {
  type        = string
  description = "CIDR range for the Private Service Connect subnet."
}

variable "deploy_proxy_subnetwork" {
  type        = bool
  description = "Deploy 'Proxy' Subnetwork. In a given network, there can be only one; set to false if one already exists"
}