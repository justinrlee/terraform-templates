# Have to get a list of domain files, including the one that will be created by the above resource if it doesn't already exist
locals {
  domains =  setunion(
          toset(fileset("${path.module}/../_generated_dns", "*.cloud")), [confluent_network.network.dns_domain]
        , [confluent_network.network.dns_domain]
      )
}

resource "local_file" "external_dns_db" {
  count      = var.external ? 1 : 0
  filename = "${path.module}/../_generated_dns/${confluent_network.network.dns_domain}"

  content = templatefile("${path.module}/../configurations/dns_db.tpl",
    {
      domain = confluent_network.network.dns_domain,

      # For external DNS, use the external proxy for the given region
      # (for internal DNS for other regions, use internal proxy; for internal DNS for same rgion, use PSC endpoints)
      zone_ip_mappings = {
        "${var.zones[0]}": google_compute_address.external_proxy[0].address,
        "${var.zones[1]}": google_compute_address.external_proxy[0].address,
        "${var.zones[2]}": google_compute_address.external_proxy[0].address,
      }
    }
  )
}

resource "local_file" "Corefile" {
  count      = var.external ? 1 : 0
  # for_each = var.regions

  filename = "${path.module}/../_generated_dns/Corefile"

  content = templatefile("${path.module}/../configurations/Corefile.tpl",
    {
      domains = local.domains,
    }
  )

  depends_on = [
    local_file.external_dns_db
  ]
}
