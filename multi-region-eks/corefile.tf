
data "dns_a_record_set" "nlb_r0" {
  host = kubernetes_service.dns_external_r0.status[0].load_balancer[0].ingress[0].hostname
}

data "dns_a_record_set" "nlb_r1" {
  host = kubernetes_service.dns_external_r1.status[0].load_balancer[0].ingress[0].hostname
}

data "dns_a_record_set" "nlb_r2" {
  host = kubernetes_service.dns_external_r2.status[0].load_balancer[0].ingress[0].hostname
}

resource "local_file" "corefile_r0" {
  filename = "run.corefile-${var.regions_short[0]}.yml"

  content = templatefile(
    "${path.module}/templates/Corefile.yml.tpl",
    {
      ns1 = "confluent-${var.regions_short[1]}",
      ns2 = "confluent-${var.regions_short[2]}",
      ns1_ip1 = data.dns_a_record_set.nlb_r1.addrs[0]
      ns1_ip2 = data.dns_a_record_set.nlb_r1.addrs[1]
      ns2_ip1 = data.dns_a_record_set.nlb_r2.addrs[0]
      ns2_ip2 = data.dns_a_record_set.nlb_r2.addrs[1]
    }
  )
}

resource "local_file" "corefile_r1" {
  filename = "run.corefile-${var.regions_short[1]}.yml"

  content = templatefile(
    "${path.module}/templates/Corefile.yml.tpl",
    {
      ns1 = "confluent-${var.regions_short[0]}",
      ns2 = "confluent-${var.regions_short[2]}",
      ns1_ip1 = data.dns_a_record_set.nlb_r0.addrs[0]
      ns1_ip2 = data.dns_a_record_set.nlb_r0.addrs[1]
      ns2_ip1 = data.dns_a_record_set.nlb_r2.addrs[0]
      ns2_ip2 = data.dns_a_record_set.nlb_r2.addrs[1]
    }
  )
}

resource "local_file" "corefile_r2" {
  filename = "run.corefile-${var.regions_short[2]}.yml"

  content = templatefile(
    "${path.module}/templates/Corefile.yml.tpl",
    {
      ns1 = "confluent-${var.regions_short[0]}",
      ns2 = "confluent-${var.regions_short[1]}",
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