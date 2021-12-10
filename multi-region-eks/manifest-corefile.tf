
# Can't use count or for_each for the kubernetes services, because they're in different providers

data "dns_a_record_set" "nlb_r0" {
  host = kubernetes_service.dns_external_r0.status[0].load_balancer[0].ingress[0].hostname
}

data "dns_a_record_set" "nlb_r1" {
  host = kubernetes_service.dns_external_r1.status[0].load_balancer[0].ingress[0].hostname
}

data "dns_a_record_set" "nlb_r2" {
  host = kubernetes_service.dns_external_r2.status[0].load_balancer[0].ingress[0].hostname
}


# This doesn't actually have to be rendered, but it's more consistent to do so
resource "local_file" "corefile_default" {
  filename = "run/default-corefile.yml"

  content = templatefile(
    "${path.module}/templates/corefile.default.yml.tpl",
    {}
  )
}

resource "local_file" "corefile_r0" {
  filename = "run/${var.regions_short[0]}-corefile.yml"

  content = templatefile(
    "${path.module}/templates/corefile.yml.tpl",
    {
      ns1 = local.namespaces[1],
      ns2 = local.namespaces[2],
      ns1_ip1 = data.dns_a_record_set.nlb_r1.addrs[0]
      ns1_ip2 = data.dns_a_record_set.nlb_r1.addrs[1]
      ns2_ip1 = data.dns_a_record_set.nlb_r2.addrs[0]
      ns2_ip2 = data.dns_a_record_set.nlb_r2.addrs[1]
    }
  )
}

resource "local_file" "corefile_r1" {
  filename = "run/${var.regions_short[1]}-corefile.yml"

  content = templatefile(
    "${path.module}/templates/corefile.yml.tpl",
    {
      ns1 = local.namespaces[0],
      ns2 = local.namespaces[2],
      ns1_ip1 = data.dns_a_record_set.nlb_r0.addrs[0]
      ns1_ip2 = data.dns_a_record_set.nlb_r0.addrs[1]
      ns2_ip1 = data.dns_a_record_set.nlb_r2.addrs[0]
      ns2_ip2 = data.dns_a_record_set.nlb_r2.addrs[1]
    }
  )
}

resource "local_file" "corefile_r2" {
  filename = "run/${var.regions_short[2]}-corefile.yml"

  content = templatefile(
    "${path.module}/templates/corefile.yml.tpl",
    {
      ns1 = local.namespaces[0],
      ns2 = local.namespaces[1],
      ns1_ip1 = data.dns_a_record_set.nlb_r0.addrs[0]
      ns1_ip2 = data.dns_a_record_set.nlb_r0.addrs[1]
      ns2_ip1 = data.dns_a_record_set.nlb_r1.addrs[0]
      ns2_ip2 = data.dns_a_record_set.nlb_r1.addrs[1]
    }
  )
}

# Currently fails because this is managed by EKS: configmaps "coredns" already exists
# resource "kubernetes_config_map" "example" {
#   metadata {
#     name = "coredns"
#     namespace = "kube-system"
#   }

#   data = {
#     Corefile             = templatefile(
#       "${path.module}/templates/Corefile.tpl",
#       {
#         ns1 = "confluent-${var.regions_short[1]}",
#         ns2 = "confluent-${var.regions_short[2]}",
#         ns1_lb = kubernetes_service.dns_external_r1.status[0].load_balancer[0].ingress[0].hostname
#         ns2_lb = kubernetes_service.dns_external_r2.status[0].load_balancer[0].ingress[0].hostname
#       }
#     )
#   }

#   provider = kubernetes.eks_r0
# }