resource "kubernetes_namespace" "confluent_r0" {
  metadata {
    name = "confluent-${var.regions_short[0]}"
  }

  depends_on = [
    module.eks_cluster_r0
    # kubernetes_namespace.confluent
  ]

  provider = kubernetes.eks_r0
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.r0.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.r0.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.r0.token
  }

  alias  = "r0h"
}

resource "helm_release" "confluent_for_kubernetes_r0" {
  name = "confluent-for-kubernetes"

  repository = "https://packages.confluent.io/helm"
  chart      = "confluent-for-kubernetes"

  namespace = "confluent-${var.regions_short[0]}"

  set {
    name = "namespaced"
    value = "false"
  }

  depends_on = [
    aws_autoscaling_group.r0_workers,
    kubernetes_namespace.confluent_r0,
  ]

  provider = helm.r0h
}