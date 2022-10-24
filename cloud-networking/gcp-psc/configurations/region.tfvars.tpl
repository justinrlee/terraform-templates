# This can be auto-generated by the parent terraform repo
environment_name             = "${environment_name}"
owner                        = "${owner}"

google_project               = "${google_project}"

google_compute_network_name  = "${google_compute_network_name}"
confluent_environment_id     = "${confluent_environment_id}"

# Set up internal-facing, external-facing, or dual proxies
internal                       = "${internal}"
external                       = "${external}"
# Whitelist for source IPs for the external-facing proxy (if applicable)
external_proxy_whitelist       = [
  %{ for whitelist in external_proxy_whitelist ~}
    "${whitelist}",
  %{ endfor ~}
]

# Region-specific configurations
region                       = "${region}"
google_compute_subnetwork_name = "${google_compute_subnetwork_name}"
zones = [
  %{ for zone in zones ~}
    "${zone}",
  %{ endfor ~}
]
