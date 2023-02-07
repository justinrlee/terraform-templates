resource "kubernetes_namespace" "r2" {
  metadata {
    name = "confluent"
  }

  depends_on = [
    module.r2_eks
  ]

  provider = kubernetes.r2
}

resource "helm_release" "r2" {
  name = "confluent-for-kubernetes"

  repository = "https://packages.confluent.io/helm"
  chart      = "confluent-for-kubernetes"

  namespace = "confluent"

  set {
    name = "namespaced"
    value = "false"
  }

  depends_on = [
    kubernetes_namespace.r2,
  ]

  provider = helm.r2
}