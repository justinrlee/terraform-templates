# # WIP - needs to be modified

resource "kubernetes_config_map" "external_coredns" {
  count = var.external_coredns_nlb ? 1 : 0
  metadata {
    name      = "coredns"
    namespace = var.namespace
  }

  binary_data = merge({
    "Corefile" = "${filebase64(local_file.Corefile[0].filename)}"
    }, {
    # for domain in local.domains: "${domain}" => "${filebase64("${path.module}/../_generated_dns/${domain}")}"
    "${confluent_network.network.dns_domain}" = "${filebase64(local_file.external_dns_db[0].filename)}"
  })

  depends_on = [
    kubernetes_namespace.proxy,
    local_file.external_dns_db,
    local_file.Corefile,
  ]
}

resource "kubernetes_deployment" "external_coredns" {
  count      = var.external_coredns_nlb ? 1 : 0
  depends_on = [kubernetes_config_map.external_coredns]

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

          volume_mount {
            name       = "config"
            mount_path = "/${confluent_network.network.dns_domain}"
            sub_path   = confluent_network.network.dns_domain
            read_only  = true
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