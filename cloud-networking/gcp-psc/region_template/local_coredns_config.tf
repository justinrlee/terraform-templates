
resource "local_file" "external_dns_db" {
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

# Have to get a list of domain files, including the one that will be created by the above resource if it doesn't already exist
locals {
  domains =  setunion(
          toset(fileset("${path.module}/../_generated_dns", "*.cloud")), [confluent_network.network.dns_domain]
        , [confluent_network.network.dns_domain]
      )
}

resource "local_file" "Corefile" {
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

resource "kubernetes_config_map" "coredns" {
  metadata {
    name      = "coredns"
    namespace = var.namespace
  }

  binary_data = merge({
    "Corefile" = "${filebase64("${path.module}/../_generated_dns/Corefile")}"
  }, {
    for domain in local.domains: "${domain}" => "${filebase64("${path.module}/../_generated_dns/${domain}")}"
  })
  
  depends_on = [
    kubernetes_namespace.proxy,
    local_file.external_dns_db,
    local_file.Corefile,
  ]
}


resource "kubernetes_deployment" "coredns" {
  depends_on = [kubernetes_config_map.coredns]

  metadata {
    name      = "coredns"
    namespace = var.namespace
    labels = {
      app = "coredns"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "coredns"
      }
    }

    template {
      metadata {
        labels = {
          app                      = "coredns"
          "app.kubernetes.io/name" = "coredns"
        }
      }

      spec {
        container {
          image = "coredns/coredns:latest"
          name  = "coredns"

          volume_mount {
            name       = "config"
            mount_path = "/Corefile"
            sub_path   = "Corefile"
            read_only  = true
          }

          dynamic "volume_mount" {
            for_each = local.domains

            content {
              name = "config"
              mount_path = "/${volume_mount.key}"
              sub_path = "${volume_mount.key}"
              read_only = true
            }
          }

        }

        volume {
          name = "config"
          config_map {
            name = "coredns"
          }
        }
      }
    }
  }
}

resource "google_compute_address" "external_coredns" {
  count = true ? 1 : 0

  name = "${var.environment_name}-${var.region}-coredns-ip"

  region = var.region

  address_type = "EXTERNAL"
}


resource "kubernetes_service" "external_coredns" {
  count = true ? 1 : 0
  depends_on = [kubernetes_deployment.coredns]

  spec {
    load_balancer_ip = google_compute_address.external_coredns[0].address
    # load_balancer_source_ranges = var.external_proxy_whitelist

    selector = {
      "app.kubernetes.io/name" = "coredns"
    }
    # session_affinity = "ClientIP"
    port {
      name        = "dns"
      port        = 53
      target_port = 53
      protocol    = "UDP"
    }

    type = "LoadBalancer"

  }

  metadata {
    name      = "coredns-external"
    namespace = var.namespace
  }
}
