data "google_compute_regions" "available" {}

resource "google_dns_managed_zone" "psc_endpoint_hz" {
  name     = "${var.environment_name}-${var.region}-ccloud-${local.network_id}"
  dns_name = "${local.dns_domain}."

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.google_compute_network.vpc.id
    }
  }
}

# output "regions" {
#   value = setsubtract((data.google_compute_regions.available.names), [var.region])
# }

resource "google_dns_record_set" "psc_endpoint_rs" {
  name = "*.${google_dns_managed_zone.psc_endpoint_hz.dns_name}"
  type = "A"
  ttl  = 60

  managed_zone = google_dns_managed_zone.psc_endpoint_hz.name

  routing_policy {
    geo {
      location = var.region
      rrdatas = [
        for zone in var.zones : google_compute_address.psc_endpoint_ip[zone].address
      ]
    }

    dynamic "geo" {
      for_each = setsubtract((data.google_compute_regions.available.names), [var.region])

      content {
        location = geo.key
        rrdatas  = [var.internal ? google_compute_address.internal_proxy[0].address : var.external ? google_compute_address.external_proxy[0].address : null]
      }
    }
  }
}

resource "google_dns_record_set" "psc_endpoint_zonal_rs" {
  for_each = toset(var.zones)

  name = "*.${each.key}.${google_dns_managed_zone.psc_endpoint_hz.dns_name}"
  type = "A"
  ttl  = 60

  managed_zone = google_dns_managed_zone.psc_endpoint_hz.name

  routing_policy {
    geo {
      location = var.region
      rrdatas  = [google_compute_address.psc_endpoint_ip[each.key].address]
    }

    dynamic "geo" {
      for_each = setsubtract((data.google_compute_regions.available.names), [var.region])

      content {
        location = geo.key
        rrdatas  = [var.internal ? google_compute_address.internal_proxy[0].address : var.external ? google_compute_address.external_proxy[0].address : null]
      }
    }
  }
}