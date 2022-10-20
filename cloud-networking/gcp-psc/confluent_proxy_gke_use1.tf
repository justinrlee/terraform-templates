## CHANGE THIS PER REGION
data "google_container_cluster" "use1" {
  ## CHANGE THIS PER REGION
  name = google_container_cluster.proxy["us-east1"].name
  ## CHANGE THIS PER REGION
  location = "us-east1"
}

provider "kubernetes" {
  ## CHANGE THIS PER REGION
  host = "https://${data.google_container_cluster.use1.endpoint}"
  ## CHANGE THIS PER REGION
  cluster_ca_certificate = base64decode(data.google_container_cluster.use1.master_auth[0].cluster_ca_certificate, )
  ## CHANGE THIS PER REGION
  alias = "use1"

  token = data.google_client_config.provider.access_token
}

## CHANGE THIS PER REGION
resource "kubernetes_namespace" "use1" {
  ## CHANGE THIS PER REGION
  depends_on = [google_container_cluster.proxy["us-east1"]]
  ## CHANGE THIS PER REGION
  provider = kubernetes.use1

  metadata {
    name = var.namespace
  }
}

## CHANGE THIS PER REGION
resource "kubernetes_config_map" "use1" {
  ## CHANGE THIS PER REGION
  depends_on = [kubernetes_namespace.use1]
  ## CHANGE THIS PER REGION
  provider = kubernetes.use1

  metadata {
    name      = "nginx-config"
    namespace = var.namespace
  }

  data = {
    "nginx.conf" = "${file("${path.module}/configurations/google.conf")}"
  }
}

## CHANGE THIS PER REGION
resource "kubernetes_deployment" "use1" {
  ## CHANGE THIS PER REGION
  depends_on = [kubernetes_config_map.use1]
  ## CHANGE THIS PER REGION
  provider = kubernetes.use1

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
            read_only  = true
            sub_path   = "nginx.conf"
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

## CHANGE THIS PER REGION
resource "kubernetes_service" "use1" {
  ## CHANGE THIS PER REGION
  depends_on = [kubernetes_namespace.use1]
  ## CHANGE THIS PER REGION
  provider = kubernetes.use1

  spec {
    ## CHANGE THIS PER REGION
    load_balancer_ip = google_compute_address.proxy["us-east1"].address

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
    name      = "nginx"
    namespace = var.namespace
  }
}