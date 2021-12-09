resource "kubernetes_namespace" "confluent_r1" {
  metadata {
    name = "confluent-${var.regions_short[1]}"
  }

  depends_on = [
    module.eks_cluster_r1
    # kubernetes_namespace.confluent
  ]

  provider = kubernetes.eks_r1
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.r1.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.r1.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.r1.token
  }

  alias  = "r1h"
}

resource "helm_release" "confluent_for_kubernetes_r1" {
  name = "confluent-for-kubernetes"

  repository = "https://packages.confluent.io/helm"
  chart      = "confluent-for-kubernetes"

  namespace = "confluent-${var.regions_short[1]}"

  set {
    name = "namespaced"
    value = "false"
  }

  depends_on = [
    aws_autoscaling_group.r1_workers,
    kubernetes_namespace.confluent_r1,
  ]

  provider = helm.r1h
}