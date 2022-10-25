# Region terraform (Child directory)
Create a copy of the `/region` terraform directory for _each_ region you want to do this for (at `region_<regionname>`). Each region terraform will create the following resources:

`_parent_data.tf`: No resources, only data reads

`confluent_infra.tf`: depends on parent only
* Confluent Cloud Network (CCN) configured for PSC in the relevant zones
* PSC Access (PrivateLink Access) granting the project access to the network

`confluent_kafka_cluster.tf`: depends on `confluent_infra.tf`
* Dedicated, Single-Zone PSC cluster in the CCN

`gcp_gke_cluster.tf`: depends on parent only
* GKE cluster (in-region)

`gcp_private_endpoint.tf`: depends on `confluent_infra.tf`
* 3x private static IP, one for each AZ
* 3x private endpoint forwarding rule, pointing the static IP at the PSC endpoint

`gcp_proxy_ip.tf`: depends on parent only
* (Optional) static private IP for proxy LB
* (Optional) static public IP for proxy LB

_Private and public can be toggled individually; assumption is that you have at least one_

`gcp_private_zone.tf`: depends on `confluent_infra.tf`, `gcp_private_endpoint.tf`
* Private DNS Zone
* 1x record set for top-level wildcard
    * For local region, three private static IPs (PSC private endpoints)
    * For all other regions, one private (or public) static IP (pointing at the internal or external proxy LB)
* 1x record set for *each* zonal wildcard, each with 1 entry
    * For local region, one private static IPs (PSC private endpoint)
    * For all other regions, one private (or public) static IP (pointing at the internal or external proxy LB)

`kubernetes_proxy_resources.tf`: depends on `gcp_gke_cluster.tf` and `gcp_proxy_ip.tf`
* Namespace for proxy layer
* ConfigMap for NGINX
* Deployment for NGINX
* (Optional) Internal LoadBalancer Service for NGINX
* (Optional) External LoadBalancer Service for NGINX

---

```mermaid
%%{init: {"theme": "forest", "logLevel": 1 }}%%
erDiagram
    parent_data ||--|| confluent_infra: ""
    parent_data ||--|| gcp_gke_cluster: ""
    parent_data ||--|| gcp_proxy_ip: ""
    confluent_infra ||--|| gcp_private_endpoint: ""
    confluent_infra ||--|| gcp_private_zone: ""
    confluent_infra ||--|| confluent_kafka_cluster: ""
    gcp_gke_cluster ||--|| kubernetes_proxy_resources: ""
    gcp_private_endpoint ||--|| gcp_private_zone: ""
    gcp_proxy_ip ||--|| kubernetes_proxy_resources: ""

    confluent_infra {
      confluent_network network
      confluent_private_link_access gcp
    }

    confluent_kafka_cluster {
      confluent_kafka_cluster kafka
    }

    gcp_gke_cluster {
      google_container_cluster proxy
    }

    gcp_private_endpoint {
      google_compute_address psc_endpoint_ip_0
      google_compute_address psc_endpoint_ip_1
      google_compute_address psc_endpoint_ip_2
      google_compute_forwarding_rule psc_endpoint_ilb_0
      google_compute_forwarding_rule psc_endpoint_ilb_1
      google_compute_forwarding_rule psc_endpoint_ilb_2
    }

    gcp_proxy_ip {
      google_compute_address external_proxy
      google_compute_address internal_proxy
    }

    gcp_private_zone {
      google_dns_managed_zone ccn_zone
      google_dns_record_set psc_regional
      google_dns_record_set psc_zonal_0
      google_dns_record_set psc_zonal_1
      google_dns_record_set psc_zonal_2
    }
    kubernetes_proxy_resources {
      google_container_cluster proxy
      kubernetes_namespace proxy
      kubernetes_config_map nginx
      kubernetes_deployment nginx
      kubernetes_service external_nginx
      kubernetes_service internal_nginx
    }


```

