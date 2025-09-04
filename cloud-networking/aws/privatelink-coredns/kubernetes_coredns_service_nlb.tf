resource "kubernetes_service" "external_coredns_nlb" {
  count      = var.external_coredns_nlb ? 1 : 0
  depends_on = [
    kubernetes_namespace.proxy,
    kubernetes_deployment.external_coredns,
    helm_release.albc,
    time_sleep.coredns_nlb,
  ]

  spec {
    load_balancer_class = "service.k8s.aws/nlb"

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
    name      = "coredns-external-nlb"
    namespace = var.namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
      "service.beta.kubernetes.io/aws-load-balancer-attributes"      = "load_balancing.cross_zone.enabled=true"
      "service.beta.kubernetes.io/aws-load-balancer-eip-allocations" = join(",", [for eip in aws_eip.coredns_nlb : eip.allocation_id])
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
    }
  }
}
