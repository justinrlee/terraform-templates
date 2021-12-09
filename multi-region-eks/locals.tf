locals {
  namespaces = [for rs in var.regions_short: "confluent-${rs}"]
}