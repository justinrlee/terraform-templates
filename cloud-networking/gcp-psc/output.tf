output "confluent_environment_id" {
  value = confluent_environment.demo.id
}

output "google_compute_network_name" {
  value = google_compute_network.vpc.name
}

output "jump_box" {
  # value = google_compute_instance.default[*]
  value = {
    for instance, properties in google_compute_instance.default : properties.name => properties.network_interface[0].access_config[0].nat_ip
  }
  # sensitive = true
}