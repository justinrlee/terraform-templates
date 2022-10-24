environment_name             = "${environment_name}"
owner                        = "${owner}"
google_project               = "${google_project}"
google_compute_network_name  = "${google_compute_network_name}"
confluent_environment_id     = "${confluent_environment_id}"


internal                       = "${internal}"
external                       = "${external}"
external_proxy_whitelist       = [
  %{ for whitelist in external_proxy_whitelist ~}
    "${whitelist}",
  %{ endfor ~}
]

region                       = "${region}"
google_compute_subnetwork_name = "${google_compute_subnetwork_name}"
zones = [
  %{ for zone in zones ~}
    "${zone}",
  %{ endfor ~}
]