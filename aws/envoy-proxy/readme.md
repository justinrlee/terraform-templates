# Envoy Proxy for Confluent Cloud

Expose a Confluent Cloud Peering Cluster on the Internet with AWS NLBs, using Envoy proxy (using the `contrib` "Kafka Broker" filter)

Consists of three terraform templates:
* "prereqs" Prerequisites (in the real world, these already exist)
    * AWS VPC with three (3) AZs, with the following:
        * 1x IGW
        * 3x Public Subnets (for NLB)
        * 3x Private Subnets (for envoy)
        * NAT Gateway for each private subnet
    * 3x Elastic IP
    * 3x NLB (with Elastic IP)
        * with security group (tbd ports)
    * Bastion instance
* "peering" sets up routes for peering connection
* "proxy" - Proxy components, which depend on the above prerequisites:
    * 49x NLB TLS listeners for each NLB (49 per AZ, 147 total)
        * 1x bootstrap listener (9092)
        * 48x broker listeners
    * Target group for each listener (49 per AZ, 147 total)
    * 3x ASG (one per zone), with EC2 instances, running Envoy
    * Each NLB will responsible for 48 brokers (supports 144 total brokers, i.e. 192 CKU ultra cluster)
    * R53 records pointing at the NLBs

Also assumes that these will be created out of band:
* ACM certificate, with four hostnames (or wildcard covering these):
    * regional hostname (`kafka-apse1.confluent.justinrlee.io`)
    * 3x zonal hostnames (`kafka-apse1-az1.confluent.justinrlee.io`, `kafka-apse1-az2.confluent.justinrlee.io`, and `kafka-apse1-az3.confluent.justinrlee.io`)
* Peering between Confluent Cloud and VPC, including routes
* R53 zone

envoy is configured as follows:
* TLS termination in front of envoy (on NLB)
* TLS initiation to backend Kafka cluster

Comments:
* Requires an ACM certificate matching a Route53 public hosted zone (in this example, we're using a certificate with `*.confluent.justinrlee.io` in public hosted zone `confluent.justinrlee.io`)
* Peering connection between Confluent VPC and customer VPC has to be set up out-of-band. `vpc-peering-route.tf` has sample TF to set up the routing to a pre-existing pcx, but this is not fully automated
* Envoy remaps advertised listeners, as follows:
    * Each broker gets a unique port (e.g. broker 0 is port 10000, broker 1 is 10001)
    * Advertised hostnames are mapped to the AZ that the broker exists in (e.g. if broker 0 is in apse1-az1, it'll be exposed by an NLB in apse1-az1)

envoy instances all have identical configurations:
* all advertised listener rewrites
* all listeners (9092, 10000-10143)
* only zonal listeners are actually accessed. for example:
    * az1: 9092, 10000, 10003, 10006, 10009 ... 10141
    * az2: 9092, 10001, 10004, 10007, 10010 ... 10142
    * az3: 9092, 10002, 10005, 10008, 10011 ... 10143

Continue broker mappings as follows:
* each NLB is responsible for only the brokers in its respective zone
    * az1: bootstrap, broker 0 / 3 / 6 /  9 ... 141 (49 listeners)
    * az1: bootstrap, broker 1 / 4 / 7 / 10 ... 142 (49 listeners)
    * az2: bootstrap, broker 2 / 5 / 8 / 11 ... 143 (49 listeners)