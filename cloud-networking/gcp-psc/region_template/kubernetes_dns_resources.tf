
resource "kubernetes_config_map" "external_coredns" {
  count      = var.external_dns ? 1 : 0
  metadata {
    name      = "coredns"
    namespace = var.namespace
  }

  binary_data = merge({
    "Corefile" = "${filebase64(local_file.Corefile[0].filename)}"
  }, {
    for domain in local.domains: "${domain}" => "${filebase64("${path.module}/../_generated_dns/${domain}")}"
  })
  
  depends_on = [
    kubernetes_namespace.proxy,
    local_file.external_dns_db,
    local_file.Corefile,
  ]
}

resource "kubernetes_deployment" "external_coredns" {
  count      = var.external_dns ? 1 : 0
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

resource "kubernetes_service" "external_coredns" {
  count = var.external_dns ? 1 : 0
  depends_on = [kubernetes_deployment.external_coredns]

  spec {
    load_balancer_ip = google_compute_address.external_coredns[0].address
    load_balancer_source_ranges = var.external_proxy_whitelist

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
