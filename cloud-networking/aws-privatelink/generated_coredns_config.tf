resource "local_file" "external_dns_db" {
  count      = var.external_dns ? 1 : 0
  filename = "${path.module}/_generated_dns/${confluent_network.network.dns_domain}"

  content = templatefile("${path.module}/configurations/dns_db.tpl",
    {
      domain = confluent_network.network.dns_domain,

      # For external DNS, use the external proxy for the given region
      # (for internal DNS for other regions, use internal proxy; for internal DNS for same rgion, use PSC endpoints)
      zones = var.zones
      
      endpoints = [
        for eip in aws_eip.nginx: eip.public_ip
      ]
    }
  )
}

resource "local_file" "Corefile" {
  count      = var.external_dns ? 1 : 0

  filename = "${path.module}/_generated_dns/${confluent_network.network.dns_domain}_Corefile"

  content = templatefile("${path.module}/configurations/Corefile.tpl",
    {
      # Special DNS endpoint that works across AWS
      upstream_resolver = "169.254.169.253",
      domains = [
        confluent_network.network.dns_domain,
      ],

    }
  )

  depends_on = [
    confluent_network.network
  ]
}
