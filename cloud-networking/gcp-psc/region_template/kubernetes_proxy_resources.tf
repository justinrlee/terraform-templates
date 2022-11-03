data "google_container_cluster" "proxy" {
  name     = google_container_cluster.proxy.name
  location = var.region
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.proxy.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.proxy.master_auth[0].cluster_ca_certificate, )
  token                  = data.google_client_config.provider.access_token
}

resource "kubernetes_namespace" "proxy" {
  depends_on = [google_container_cluster.proxy]

  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "nginx" {
  depends_on = [kubernetes_namespace.proxy]

  metadata {
    name      = "nginx-config"
    namespace = var.namespace
  }

  data = {
    "nginx.conf" = "${file("${path.module}/../configurations/google.conf")}"
  }
}

resource "kubernetes_deployment" "nginx" {
  depends_on = [kubernetes_config_map.nginx]

  metadata {
    name      = "nginx"
    namespace = var.namespace
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app                      = "nginx"
          "app.kubernetes.io/name" = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "nginx"

          volume_mount {
            name       = "config"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
            read_only  = true
          }
        }

        volume {
          name = "config"
          config_map {
            name = "nginx-config"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "internal_nginx" {
  count      = var.internal ? 1 : 0
  depends_on = [kubernetes_namespace.proxy]

  spec {
    load_balancer_ip = google_compute_address.internal_proxy[0].address

    selector = {
      "app.kubernetes.io/name" = "nginx"
    }
    # session_affinity = "ClientIP"
    port {
      name        = "kafka"
      port        = 9092
      target_port = 9092
    }
    port {
      name        = "https"
      port        = 443
      target_port = 443
    }

    type = "LoadBalancer"

  }

  metadata {
    name      = "nginx-internal"
    namespace = var.namespace
    annotations = {
      "networking.gke.io/load-balancer-type"                         = "Internal"
      "networking.gke.io/internal-load-balancer-allow-global-access" = "true"
    }
  }
}

resource "kubernetes_service" "external_nginx" {
  count      = var.external ? 1 : 0
  depends_on = [kubernetes_namespace.proxy]

  spec {
    load_balancer_ip = google_compute_address.external_proxy[0].address
    load_balancer_source_ranges = var.external_proxy_whitelist

    selector = {
      "app.kubernetes.io/name" = "nginx"
    }
    # session_affinity = "ClientIP"
    port {
      name        = "kafka"
      port        = 9092
      target_port = 9092
    }
    port {
      name        = "https"
      port        = 443
      target_port = 443
    }

    type = "LoadBalancer"

  }

  metadata {
    name      = "nginx-external"
    namespace = var.namespace
  }
}
