resource "aws_eip" "dns" {
  count = 3
  vpc = true
}


resource "kubernetes_service" "external_coredns" {
  count = var.external_dns ? 1 : 0
  depends_on = [kubernetes_deployment.external_coredns]

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
    name      = "coredns-external"
    namespace = var.namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
      "service.beta.kubernetes.io/aws-load-balancer-attributes" = "load_balancing.cross_zone.enabled=true"
      "service.beta.kubernetes.io/aws-load-balancer-eip-allocations" = join(",", [for eip in aws_eip.dns: eip.allocation_id])
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
    }
  }
}
