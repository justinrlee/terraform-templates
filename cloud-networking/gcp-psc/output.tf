output "confluent_environment_id" {
  value = confluent_environment.demo.id
}

output "google_compute_network_name" {
  value = google_compute_network.vpc.name
}

output "zz_jump_box" {
  # value = google_compute_instance.default[*]
  value = {
    for instance, properties in google_compute_instance.default : properties.name => properties.network_interface[0].access_config[0].nat_ip
  }
  # sensitive = true
}

output "environment_name" { value = var.environment_name }

output "owner" { value = var.owner }

output "google_project" { value = var.google_project }

# output "regional_tfvars" {
#   value = {
#     for k, v in var.regions :
#     k => {
#       environment_name : var.environment_name,
#       owner : var.owner,
#       google_project : var.google_project
#       google_compute_network_name : google_compute_network.vpc.name,
#       confluent_environment_id : confluent_environment.demo.id,
#       google_compute_subnetwork_name : google_compute_subnetwork.subnet[k].name,
#       region : k,
#       zones : v.zones,
#     }
#   }
# }