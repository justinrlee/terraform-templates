# Confluent Cloud in GCP, with PSC

This project has two levels of Terraform:
* One to automate the creation of 'infrastructure' (potentially, these would be things managed by the customer's existing automation)
* One to automate the creation of Confluent-specific infrastructure, on a per-region basis

Note: GCP is different from AWS and Azure, in these significant ways:
* GCP PSC endpoints cannot be accessed from other regions
* GCP VCPs ('networks') are global, and then have a 'subnetwork' for each region.

## Infra terraform
Infrastructure repo (top-level terraform) creates infrastructure that everything in this depends on.

It uses these variables:
`variables.tf`: Variables (see terraform.tfvars for reference config)
* Must specify Google Project
* Must indicate what regions you want to run this in, with information (CIDR and zones) you want for each region)

This terraform will consist of these resources:

`cloud_network.tf`: No dependencies
* VPC ('customer owned' global network)
* Subnetwork for each region

`cloud_instance.tf`: (optional) depends on cloud_network.tf:
* (Ubuntu) Bastion host in each subnet
* Firewall allowing SSH into the bastion host

`confluent_infra.tf`: No dependencies
* Confluent 'environment' for provisioning Confluent resources in it (assumes you already have a Confluent org)

`region_tfvars.output.tf`: Depends on everything else
* For each region, will generate a tfvars file for the region-specific Terraform (at `region_<regionname>/terraform.tfvars`)

## Region terraform
Create a copy of the `/region` terraform directory for _each_ region you want to do this for (at `region_<regionname>`). Each region terraform will create the following resources:

`_parent_data.tf`: No resources, only data reads

`confluent_infra.tf`: For each region:
* Confluent Cloud Network (CCN) configured for PSC in the relevant zones
* PSC Access (PrivateLink Access) granting the project access to the network

`confluent_kafka_cluster.tf`:
* Dedicated, Single-Zone PSC cluster in the CCN

`confluent_private_endpoint.tf`:
* 3x private static IP, one for each AZ
* 3x private endpoint forwarding rule, pointing the static IP at the PSC endpoint




## Example usage

In the top-level directory:

```bash

gcp-psc % export CONFLUENT_CLOUD_API_KEY=xyz123
gcp-psc % export CONFLUENT_CLOUD_API_SECRET=abcdef

gcp-psc % terraform init

...
... Output omitted
...

gcp-psc % terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

...
... Output omitted
...

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

confluent_environment.demo: Creating...

...
... Output omitted
...

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

confluent_environment_id = "env-6k9yjj"
environment_name = "justinlee-psc"
google_compute_network_name = "justinlee-psc"
google_project = "sales-engineering-206314"
owner = "justinlee"
zz_jump_box = {
  "justinlee-psc-us-east1" = "35.196.145.50"
  "justinlee-psc-us-east4" = "34.86.2.33"
}
```

See created directories:

```
gcp-psc % ls -alh
total 200
drwxr-xr-x  23 jlee  staff   736B Oct 24 10:58 .
drwxr-xr-x   3 jlee  staff    96B Oct 20 10:38 ..
...
drwxr-xr-x  14 jlee  staff   448B Oct 24 10:54 region
...
drwxr-xr-x  18 jlee  staff   576B Oct 24 10:57 region_us-east1
drwxr-xr-x  18 jlee  staff   576B Oct 24 10:57 region_us-east4
...
```

See generated tfvars:

```
gcp-psc % ls region_*
region_us-east1:
terraform.tfvars

region_us-east4:
terraform.tfvars
```

To create a child region, copy the `_region_tpl` template directory 

```
gcp-psc % cp -rpv _region_tpl region_us-east
_region_tpl -> region_us-east
_region_tpl/output.tf -> region_us-east/output.tf
_region_tpl/confluent_infra.tf -> region_us-east/confluent_infra.tf
_region_tpl/confluent_private_endpoint.tf -> region_us-east/confluent_private_endpoint.tf
_region_tpl/confluent_kafka_cluster.tf -> region_us-east/confluent_kafka_cluster.tf
_region_tpl/_parent_data.tf -> region_us-east/_parent_data.tf
_region_tpl/providers.tf -> region_us-east/providers.tf
_region_tpl/readme.md -> region_us-east/readme.md
_region_tpl/confluent_proxy.tf -> region_us-east/confluent_proxy.tf
_region_tpl/sample.tfvars -> region_us-east/sample.tfvars
_region_tpl/variables.tf -> region_us-east/variables.tf
_region_tpl/confluent_proxy_resources.tf -> region_us-east/confluent_proxy_resources.tf
_region_tpl/confluent_private_zone.tf -> region_us-east/confluent_private_zone.tf
```


## Example

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
