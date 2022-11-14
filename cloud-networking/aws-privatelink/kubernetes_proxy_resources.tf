
resource "kubernetes_namespace" "proxy" {
  depends_on = [
    module.eks
  ]

  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "nginx" {
  depends_on = [
    kubernetes_namespace.proxy
  ]

  metadata {
    name      = "nginx-config"
    namespace = var.namespace
  }

  data = {
    "nginx.conf" = "${file("${path.module}/configurations/aws.conf")}"
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