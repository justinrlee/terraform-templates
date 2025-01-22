

locals  {
    namespace_manifest = {
        apiVersion = "v1"
        kind = "Namespace"
        metadata = {
            labels = {
                "kubernetes.io/metadata.name" = var.namespace
            }
            name = var.namespace
        }
    }

    deployment_manifest = {
        for az in var.zones:
        az => 
        {
            apiVersion = "apps/v1"
            kind = "Deployment"
            metadata = {
                name = "kafka-proxy-${az}"
                namespace = var.namespace
                labels = {
                    app = "kafka-proxy"
                    zone = az
                }
            }
            spec = {
                replicas = 2
                selector = {
                    matchLabels = {
                        zone = az
                        app = "kafka-proxy"
                    }
                }
                template = {
                    metadata = {
                        labels = {
                            zone = az
                            app = "kafka-proxy"
                        }
                    }
                    spec = {
                        affinity = {
                            nodeAffinity = {
                                requiredDuringSchedulingIgnoredDuringExecution = {
                                    nodeSelectorTerms = [
                                      {
                                        matchExpressions = [{
                                            key = "topology.k8s.aws/zone-id"
                                            operator = "In"
                                            values = [
                                                az
                                            ]
                                        }]
                                      }
                                    ]
                                }
                            }
                        }
                        containers = [{
                            name = "kafka-proxy"
                            image = var.image
                            env = [
                                {
                                    name = "UPSTREAM_BOOTSTRAP",
                                    value = var.upstream_bootstrap
                                },
                                {
                                    name = "PROXY_EX",
                                    value = var.regional_endpoint
                                },
                                {
                                    name = "PROXY_E0",
                                    value = var.zonal_endpoint[var.zones[0]]
                                },
                                {
                                    name = "PROXY_E1",
                                    value = var.zonal_endpoint[var.zones[1]]
                                },
                                {
                                    name = "PROXY_E2",
                                    value = var.zonal_endpoint[var.zones[2]]
                                },
                            ]
                        }]
                    }
                }
            }
        }
    }

    service_manifest = {
        for az, config in {"apse1-az1": {}, "apse1-az2": {}, "apse1-az3": {}}:
        az => 
        {
            apiVersion = "v1"
            kind = "Service"
            metadata = {
                name = "kafka-proxy-${az}"
                namespace = var.namespace
                labels = {
                    app = "kafka-proxy"
                    zone = az
                }
            }
            spec = {
                sessionAffinity = "None"
                type = "ClusterIP"
                selector = {
                    zone = az
                    app = "kafka-proxy"
                }
                ports = [
                    for p in concat([9092], range(10000,10000+48*3)):
                    {
                        name = "p${p}"
                        port = p
                        targetPort = p
                        protocol = "TCP"
                    }
                ]
            }
        }
    }

    targetgroupbinding_manifest = {
        for k,v in var.target_groups:
            k => {
                apiVersion = "elbv2.k8s.aws/v1beta1"
                kind = "TargetGroupBinding"
                metadata = {
                    name = k
                    namespace = var.namespace
                }
                spec = {
                    serviceRef = {
                        name = "kafka-proxy-${v.zone}"
                        port = "p${v.port}"
                    }
                    targetType = "ip"
                    targetGroupARN = v.arn
                }
            }

    }
    
}

resource "local_file" "namespace" {
    content = jsonencode(local.namespace_manifest)
    filename = "${path.module}/manifests/namespace.json"
}

resource "local_file" "deployment" {
    for_each = local.deployment_manifest
    content = jsonencode(each.value)
    filename = "${path.module}/manifests/deployment-${each.key}.json"
}

resource "local_file" "service" {
    for_each = local.service_manifest
    content = jsonencode(each.value)
    filename = "${path.module}/manifests/service-${each.key}.json"
}

resource "local_file" "targetgroupbinding" {
    for_each = local.targetgroupbinding_manifest
    content = jsonencode(each.value)
    filename = "${path.module}/manifests/targetgroupbinding-${each.key}.json"
}

output "namespace_manifest" {
    value = local.namespace_manifest
}