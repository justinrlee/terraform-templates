module "load_balancer_controller_irsa_role" {
  # Double slash indicates path within repo
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-role-for-service-accounts-eks"

  role_name                              =  var.controller_name
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.controller_namespace}:${var.controller_name}"]
    }
  }

  tags = { 
    owner_email = var.owner
    Terraform = true
  }

  depends_on = [
    module.eks
  ]
}

resource "kubernetes_service_account" "albc" {
  metadata {
    namespace = var.controller_namespace
    name = var.controller_name
    annotations = {
      "eks.amazonaws.com/role-arn" = module.load_balancer_controller_irsa_role.iam_role_arn
    }
  }

  depends_on = [
    module.eks,
    module.load_balancer_controller_irsa_role,
  ]
}

resource "helm_release" "albc" {
  name =  var.controller_name
  chart = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"

  namespace = var.controller_namespace
  cleanup_on_fail =  true

  set {
    name = "serviceAccount.name"
    value = var.controller_name
  }

  set {
    name = "serviceAccount.create"
    value = "false"
  }

  set {
    name = "clusterName"
    value = var.environment_name
  }

  set {
    name = "hostNetwork"
    value = "true"
  }

  depends_on = [
    module.eks,
    module.load_balancer_controller_irsa_role,
    kubernetes_service_account.albc,
  ]
}