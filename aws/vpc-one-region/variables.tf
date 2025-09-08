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
variable "public_volume_type" {
    default = "gp3"
}
variable "public_volume_iops" {
    default = 3000
}
variable "public_volume_throughput" {
    default = 125
}