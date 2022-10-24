resource "local_file" "tfvars" {
  for_each = var.regions

  filename = "${path.module}/region_${each.key}/terraform.tfvars"

  content = templatefile("${path.module}/configurations/region.tfvars.tpl",
    {
      environment_name               = var.environment_name,
      owner                          = var.owner,
      google_project                 = var.google_project
      google_compute_network_name    = google_compute_network.vpc.name,
      confluent_environment_id       = confluent_environment.demo.id,
      internal                       = var.internal_proxy,
      external                       = var.external_proxy,
      external_proxy_whitelist       = var.external_proxy_whitelist
      google_compute_subnetwork_name = google_compute_subnetwork.subnet[each.key].name,
      region : each.key,
      zones = each.value.zones,
    }
  )
}