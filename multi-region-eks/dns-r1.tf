resource "kubernetes_service" "dns_external_r1" {
  metadata {
    name = "dns-external"
    namespace = "kube-system"
    labels = {
      k8s-app = "kube-dns"
    }
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" =  "nlb"
    }
  }
  spec {
    selector = {
      k8s-app = "kube-dns"
    }
    
    port {
      name        = "dns"
      port        = 53
      target_port = 53
      protocol    = "TCP"
    }

    type = "LoadBalancer"

    load_balancer_source_ranges = ["0.0.0.0/0"]
  }

  depends_on = [
    module.eks_cluster_r1
  ]

  provider = kubernetes.eks_r1
}