# Kafka-Proxy for Confluent Cloud

Expose a Confluent Cloud Peering Cluster on the Internet with AWS NLBs, using Kafka-Proxy

Does the following:
* Create an AWS VPC with three (3) AZs, with the following:
    * 1x IGW
    * 3x Public Subnets (for NLB)
    * 3x Private Subnets (for Kafka-Proxy)
    * NAT Gateway for each private subnet
* In each AZ, create the following:
    * 2x NLB (6 total)
    * 25 NLB TLS listeners for each NLB (50 per AZ, 150 total)
        * 1x bootstrap listener (9092)
        * 24x broker listeners
    * 1x target group for each listenre (50 per AZ, 150 total)
    * ASG with EC2 instances running kafka-proxy
* Each NLB is responsible for 24 brokers (supports 144 total brokers, i.e. 192 CKU ultra cluster)

kafka-proxy is configured as follows:
* TLS termination in front of kafka-proxy (on NLB)
* TLS initiation to backend Kafka cluster

Comments:
* Requires an ACM certificate matching a Route53 public hosted zone (in this example, we're using a certificate with `*.confluent.justinrlee.io` in public hosted zone `confluent.justinrlee.io`)
* Peering connection between Confluent VPC and customer VPC has to be set up out-of-band. `vpc-peering-route.tf` has sample TF to set up the routing to a pre-existing pcx, but this is not fully automated
* Kafka-Proxy remaps advertised listeners, as follows:
    * Each broker gets a unique port (e.g. broker 0 is port 10000, broker 1 is 10001)
    * Advertised hostnames are mapped to the AZ that the broker exists in (e.g. if broker 0 is in apse1-az1, it'll be exposed by an NLB in apse1-az1)
    * Within an AZ, brokers are distributed evenly between the two NLBs (since AWS has a a limit of 25 listeners per NLB)

![kafka-proxy v2](https://github.com/user-attachments/assets/1370338b-46c4-452d-b6e6-2d10cf9c21cf)
