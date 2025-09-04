variable "google_project_id" {
  type = string
  description = "The ID of the project to use for the resources"
}

variable "google_region" {
  type = string
}

variable "google_asn" {
  type = string
}

variable "aws_asn" {
  type = string
}

variable "aws_vpc_id" {
  type = string
}

variable "google_network" {
  type        = string
  description = "Name of the GCP network."
}

variable "prefix" {
  type = string
}

variable "aws_vpc_cidr" {
  type = string
}

variable "tunnels" {
  type = list(object({
    psk = string
    cidr = string
    aws = string
    gcp = string
    ext_gwy_interface = number
    vpn_gwy_interface = number
  }))
}

locals {
  tunnels = {
    "0-0" = var.tunnels[0]
    "0-1" = var.tunnels[1]
    "1-0" = var.tunnels[2]
    "1-1" = var.tunnels[3]
  }
  num_tunnels = length(local.tunnels)
}

variable "aws_rtb_id" {
  type = string
}

variable "google_cidr" {
  type = string
}