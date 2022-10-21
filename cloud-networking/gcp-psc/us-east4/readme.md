# Confluent Cloud in GCP, with PSC

Rough dependency tree:

`cloud_network.tf`: No dependencies
* VPC parent
* Subnetwork for one region parent
* Subnetwork for second regoin parent

<!-- `cloud_vm.tf` Dependent on `gcp_infra`: One SSH-able VM in each region
* aws_security_group.all_traffic
    * aws_security_group_rule.egress
    * aws_security_group_rule.ingress_home
    * aws_security_group_rule.ingress_https
    * aws_security_group_rule.ingress_internal
* aws_instance.pre[0] -->

`confluent_infra.tf` No dependencies: Confluent environment, network, RBAC role binding (EnvironmentAdmin)
* confluent_environment.demo
    * confluent_network.network (for each region)
        * confluent_private_link_access.gcp
<!-- * confluent_service_account.justin_tf_child
    * confluent_role_binding.justin_tf_child_env -->

`confluent_kafka_cluster.tf`: Dependent on `confluent_infra.tf`; Confluent cluster and API key
* confluent_kafka_cluster.dedicated
<!-- * confluent_api_key.justin_tf_child -->

`confluent_private_endpoint.tf`: Dependent on `cloud_network.tf` and `confluent_infra.tf` (but not confluent cluster or VM)
* aws_vpc_endpoint.privatelink

* `confluent_private_zone.tf`: Dependent on `cloud_network.tf` and `confluent_private_endpoint.tf`
    * aws_route53_record.privatelink
    * aws_route53_record.privatelink_zonal["use1-az1"]
    * aws_route53_record.privatelink_zonal["use1-az2"]
    * aws_route53_record.privatelink_zonal["use1-az5"]
* aws_security_group.privatelink

`confluent_proxy.tf`: Dependent on `cloud_network.tf`
In each region:
  * Regional GKE cluster in each region
  * Static IP address for proxy in each region
Todo: look at Autopilot

`confluent_proxy_gke_<regionname>.tf`: For each region, in the GKE cluster
* All of the provider information relevant to the k8s cluster (for_each doesn't work with either multiple providers or providers in modules)
* Namespace
* Configmap
* Deployment
* LB Service
