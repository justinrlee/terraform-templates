resource "kubernetes_namespace" "confluent_r2" {
  metadata {
    name = "confluent-${var.regions_short[2]}"
  }

  depends_on = [
    module.eks_cluster_r2
    # kubernetes_namespace.confluent
  ]

  provider = kubernetes.eks_r2
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.r2.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.r2.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.r2.token
  }

  alias  = "r2h"
}

resource "helm_release" "confluent_for_kubernetes_r2" {
  name = "confluent-for-kubernetes"

  repository = "https://packages.confluent.io/helm"
  chart      = "confluent-for-kubernetes"

  namespace = "confluent-${var.regions_short[2]}"

  set {
    name = "namespaced"
    value = "false"
  }

  depends_on = [
    aws_autoscaling_group.r2_workers,
    kubernetes_namespace.confluent_r2,
  ]

  provider = helm.r2h
}