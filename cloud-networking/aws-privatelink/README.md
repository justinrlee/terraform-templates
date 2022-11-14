# Expose Confluent Cloud AWS PrivateLink Clusters

This is an example of how to expose a Confluent Cloud AWS PrivateLink cluster to clients outside of AWS

## Simplified Diagram

```mermaid
%%{init: {"theme": "neutral", "logLevel": 1, "flowchart": {"rankSpacing": 40}}}%%
flowchart LR
    K1[Dedicated Confluent Kafka Cluster]
    PSC1(("Private\nEndpoint\n"))
    NGINX["NGINX (3x)"]
    GLB1["External NGINX\nLoadBalancer\nKubernetes Service"]
    GLBDNS["External CoreDNS\nLoadBalancer\nKubernetes Service"]
    DNS["CoreDNS (3x)"]

    CLIENT["External Client"]

    subgraph CCN[Confluent Cloud Network]
        K1
    end

    classDef padding fill:none,stroke:none

    subgraph vpc[Customer VPC]
      subgraph pad1[ ]
        subgraph SN1[Subnetwork]
            subgraph pad2[ ]
              subgraph EKS[EKS Cluster]
                GLB1
                NGINX
                GLBDNS
                DNS
              end
              PSC1
            end
        end
      end
    end

    class pad1,pad2,pad3 padding
    
    GLBDNS --> DNS

    GLB1 --> NGINX --> PSC1

    PSC1 ==> K1

    CLIENT -.-> GLBDNS
    CLIENT --> GLB1
```

## Complete (Zonal) Diagram
This is more acurate

```mermaid
%%{init: {"theme": "neutral", "logLevel": 1, "flowchart": {"rankSpacing": 40}}}%%
flowchart LR
    K1[Dedicated Confluent Cluster: AZ1 Brokers]
    K2[Dedicated Confluent Cluster: AZ2 Brokers]
    K3[Dedicated Confluent Cluster: AZ3 Brokers]


    PE1(("Private\nEndpoint"))
    PE2(("Private\nEndpoint"))
    PE3(("Private\nEndpoint"))
    NGINX1["NGINX"]
    NGINX2["NGINX"]
    NGINX3["NGINX"]
    DNS1[("CoreDNS")]
    DNS2[("CoreDNS")]
    DNS3[("CoreDNS")]
    
    NGINX_LB["External NGINX\nLoadBalancer\nKubernetes Service"]
    DNS_LB["External CoreDNS\nLoadBalancer\nKubernetes Service"]
    

    CLIENT["External Client"]

    subgraph CCN[Confluent Cloud Network]
    subgraph pad4[ ]
      subgraph AZ1
        K1
      end
      subgraph AZ2
        K2
      end
      subgraph AZ3
        K3
      end
      end
    end

    classDef padding fill:none,stroke:none

    subgraph vpc[Customer VPC]
      NGINX_LB --> NGINX1
      NGINX_LB --> NGINX2
      NGINX_LB --> NGINX3
      DNS_LB -.-> DNS1
      DNS_LB -.-> DNS2
      DNS_LB -.-> DNS3

      subgraph pad1[ ]
        subgraph SN1[AZ1 Subnet]
          NGINX1 --> PE1
          DNS1
        end
        subgraph SN2[AZ2 Subnet]
          NGINX2 --> PE2
          DNS2
        end
        subgraph SN3[AZ3 Subnet]
          NGINX3 --> PE3
          DNS3
        end
      end
    end

    NGINX1 --> PE2
    NGINX1 --> PE3
    NGINX2 --> PE1
    NGINX2 --> PE3
    NGINX3 --> PE1
    NGINX3 --> PE2

    PE1 == Private Link ==> K1
    PE2 == Private Link ==> K2
    PE3 == Private Link ==> K3

    CLIENT -.-> DNS_LB
    CLIENT --> NGINX_LB

    class pad1,pad2,pad3,pad4 padding
```

# Resources

`cloud_infra.tf`: No Dependencies
* VPC (module). Consists of:
    * Internet Gateway
    * 3x Subnets
    * Route Table pointing subnets at IGW

`cloud_instance.tf`: depends on `cloud_infra.tf`: bastion host
* VM for bastion host

`cloud_kubernetes_cluster.tf`: depends on `cloud_infra.tf`: EKS cluster
* EKS cluster (module). Includes the following (among others):
    * EKS Cluster
    * Security Groups (necessary for AWS Load Balancer Controller to work)
    * 3x BottleRocket worker nodes

`cloud_kubernetes_controller.tf`: depends on `cloud_kubernetes_cluster.tf`: Runs the AWS Load Balancer Controller
* IRSA role (module)
* ALBC Kubernetes Service Account (in `kube-system` namespace)
* ALBC Helm release

`confluent_environment.tf`: No Dependencies
* Confluent environment

`confluent_infra.tf`: depends on `confluent_environment.tf`
* Confluent Cloud Network (CCN) configured for PrivateLink in the provided zones
* PrivateLink Access granting the customer AWS account access to the network

`confluent_kafka_cluster.tf`: depends on `confluent_infra.tf`
* Dedicated, Single-Zone PSC cluster in the CCN

`joint_private_endpoint.tf`: depends on `cloud_infra.tf` and `confluent_infra.tf`:
* Security Group for Private Endpoint
* Private Endpoint (one PE consists of multiple 'endpoints')

`joint_private_zone.tf`: depends on `joint_private_endpoint.tf`
* R53 Private Zone
* R53 Regional CNAME record
* 3x R53 Zonal CNAME records

`kubernetes_proxy_resources.tf`: runs on EKS (`cloud_kubernetes_cluster`)
* Namespace for proxy layer
* ConfigMap for NGINX
* Deployment for NGINX

`kubernetes_proxy_service.tf`: runs on EKS, depends on `kubernetes_proxy_resources` and AWS LBC (`cloud_kubernetes_controller`)
* 3x Elastic IPs (for load balancer)
* External LoadBalancer Service for NGINX

`generated_coredns_config.tf`: depends on `confluent_infra.tf`
* Corefile (for CoreDNS)
* Generated zone file (for CoreDNS)

`kubernetes_dns_resources.tf`: runs on EKS (`cloud_kubernetes_cluster`), depends on `generated_coredns_config`
* ConfigMap for CoreDNS
* Deployment for CoreDNS

`kubernetes_dns_service.tf`: runs on EKS, depends on `kubernetes_dns_resources` and AWS LBC (`cloud_kubernetes_controller`)
* 3x Elastic IPs (for load balancer)
* External LoadBalancer Service for CoreDNS

## Resource Map

```mermaid
%%{init: {"theme": "neutral", "logLevel": 1 }}%%
erDiagram
    variables ||--|| cloud_infra: ""
    cloud_infra ||--|| cloud_instance: ""
    cloud_infra ||--|| cloud_kubernetes_cluster: ""
    cloud_kubernetes_cluster ||--|| cloud_kubernetes_controller: ""
    cloud_kubernetes_cluster ||--|| kubernetes_proxy_resources: ""
    cloud_kubernetes_cluster ||--|| kubernetes_dns_resources: ""

    cloud_kubernetes_controller ||--|| kubernetes_proxy_service: ""
    cloud_kubernetes_controller ||--|| kubernetes_dns_service: ""

    variables ||--|| confluent_environment: ""
    confluent_environment ||--|| confluent_infra: ""
    confluent_infra ||--|| confluent_kafka_cluster: ""

    confluent_infra ||--|| generated_coredns_config: ""

    generated_coredns_config ||--|| kubernetes_dns_resources: ""

    confluent_infra ||--|| joint_private_endpoint: ""
    cloud_infra ||--|| joint_private_endpoint: ""
    joint_private_endpoint ||--|| joint_private_zone: ""

    kubernetes_proxy_service ||--|| generated_coredns_config: ""

    
    cloud_infra {
      module vpc
    }

    cloud_instance {
      aws_key_pair test
      aws_security_group bastion_ssh
      aws_security_group bastion_allow_egress
      aws_instance bastion
    }

    confluent_environment {
      confluent_environment demo
    }

    confluent_infra {
      confluent_network network
      confluent_private_link_access aws
    }

    confluent_kafka_cluster {
      confluent_kafka_cluster dedicated
    }

    cloud_kubernetes_cluster {
      module eks
    }

    cloud_kubernetes_controller {
      module IRSA_role
      helm_release albc
    }

    joint_private_endpoint {
      aws_security_group privatelink
      aws_vpc_endpoint privatelink
    }

    joint_private_zone {
      aws_route53_zone privatelink
      aws_route53_record regional
      aws_route53_record zonal_0
      aws_route53_record zonal_1
      aws_route53_record zonal_2
    }

    kubernetes_proxy_resources ||--|| kubernetes_proxy_service: ""

    kubernetes_proxy_resources {
      kubernetes_namespace proxy
      kubernetes_config_map nginx
      kubernetes_deployment nginx
    }
    
    kubernetes_proxy_service {
      aws_eip nginx_0
      aws_eip nginx_1
      aws_eip nginx_2
      kubernetes_service external_nginx
    }

    generated_coredns_config {
      local_file external_dns_db
      local_file Corefile
    }

    kubernetes_dns_resources {
      kubernetes_config_map external_coredns
      kubernetes_deployment external_coredns
    }

    kubernetes_dns_resources ||--|| kubernetes_dns_service: ""

    kubernetes_dns_service {
      aws_eip dns_0
      aws_eip dns_1
      aws_eip dns_2
      kubernetes_service external_coredns
    }
```