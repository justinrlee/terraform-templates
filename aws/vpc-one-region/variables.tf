variable "environment_name" {}
variable "owner_name" {}
variable "owner_contact" {}
variable "date_updated" {}
variable "myip" {}
variable "enable_private" {
    default = false
}

variable "public_type" {
    default = "t4g.medium"
}
variable "private_type" {
    default = "t4g.medium"
}
variable "public_volume_size" {
    default = 32
}
variable "private_volume_size" {
    default = 32
}