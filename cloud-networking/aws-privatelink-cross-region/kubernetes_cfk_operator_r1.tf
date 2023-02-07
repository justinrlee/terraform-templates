resource "kubernetes_namespace" "r1" {
  metadata {
    name = "confluent"
  }

  depends_on = [
    module.r1_eks
  ]

  provider = kubernetes.r1
}

resource "helm_release" "r1" {
  name = "confluent-for-kubernetes"

  repository = "https://packages.confluent.io/helm"
  chart      = "confluent-for-kubernetes"

  namespace = "confluent"

  set {
    name = "namespaced"
    value = "false"
  }

  depends_on = [
    kubernetes_namespace.r1,
  ]

  provider = helm.r1
}