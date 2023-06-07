resource "kubernetes_service" "external_nginx_nlb" {
  count = var.external_nginx_nlb ? 1 : 0
  depends_on = [
    kubernetes_namespace.proxy,
    kubernetes_deployment.nginx,
    helm_release.albc,
    time_sleep.nginx_nlb,
  ]

  spec {
    load_balancer_class = "service.k8s.aws/nlb"

    selector = {
      "app.kubernetes.io/name" = "nginx"
    }
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
    name      = "nginx-external-nlb"
    namespace = var.namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
      "service.beta.kubernetes.io/aws-load-balancer-attributes"      = "load_balancing.cross_zone.enabled=true"
      "service.beta.kubernetes.io/aws-load-balancer-eip-allocations" = join(",", [for eip in aws_eip.nginx_nlb : eip.allocation_id])
    }
  }
}

