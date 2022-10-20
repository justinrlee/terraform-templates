# resource "google_dns_managed_zone" "psc_endpoint_hz" {
#   name     = "ccloud-endpoint-zone-${local.network_id}"
#   dns_name = "${local.hosted_zone}."

#   visibility = "private"

#   private_visibility_config {
#     networks {
#       network_url = data.google_compute_network.psc_endpoint_network.id
#     }
#   }
# }

# resource "google_dns_record_set" "psc_endpoint_rs" {
#   name = "*.${google_dns_managed_zone.psc_endpoint_hz.dns_name}"
#   type = "A"
#   ttl  = 60

#   managed_zone = google_dns_managed_zone.psc_endpoint_hz.name
#   rrdatas = [
#   for zone, _ in var.subnet_name_by_zone : google_compute_address.psc_endpoint_ip[zone].address
#   ]
# }

# resource "google_dns_record_set" "psc_endpoint_zonal_rs" {
#   for_each = var.subnet_name_by_zone

#   name = "*.${each.key}.${google_dns_managed_zone.psc_endpoint_hz.dns_name}"
#   type = "A"
#   ttl  = 60

#   managed_zone = google_dns_managed_zone.psc_endpoint_hz.name
#   rrdatas      = [google_compute_address.psc_endpoint_ip[each.key].address]
# }