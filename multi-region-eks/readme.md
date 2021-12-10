Used to demo / test Confluent for Kubernetes on multiple EKS clusters (for MRC)

This will create many resources, that will potentially cost a lot of money.

**If you are testing this, when you go to tear it down, make sure you run `run.install.sh` and `run.validate.sh` _before_ `terraform destroy`**

This creates these resources (roughly):

* three VPCs, in three regions, with public/private subnets and IGW / NAT gateways for everything
* with all three VPCs peered to each other (cross region)
* with an EKS cluster in each VPC, with 2 workers (need to parameterize this)
* with an NLB to expose coredns for each EKS cluster (copied from CockroachDB's docs: https://www.cockroachlabs.com/docs/stable/orchestrate-cockroachdb-with-kubernetes-multi-cluster.html?filters=eks)
* with the Confluent for Kubernetes (operator) installed in each EKS cluster, in a namespace specific to that cluster

It also creates the following files:

* a k8s manifest for each EKS cluster to configure coredns for each EKS cluster so that services are routable across the three EKS clusters (can't be done with terraform because the resource is 'owned' by EKS)
* a k8s manifest to create zookeepers in all three EKS clusters (there's currently a limitation that each cluster needs an odd number of zookeepers, so you can't do 2/2/1; you either have to do 1/1/1 or 3/3/3), all in a single quorum
* k8s manifests to create brokers and observer brokers in each EKS cluster (currently rack.ids are incorrect, needs to be fixed)
* a script (`run.install.sh`) to apply the 12 k8s manifests (coredns, zookeeper, broker, observer; 3x for the three EKS clusters)
* a script (`run.uninstall.sh`) to 'uninstall' everything (remove zk, broker, observer, and revert coredns back to default)
* a script (`run.validate.sh`) to list all resources in the relevant namespaces
