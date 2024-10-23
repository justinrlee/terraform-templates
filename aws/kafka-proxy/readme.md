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

kafka-proxy instances all have identical configurations:

* all advertised listener rewrites
* all listeners (9092, 10000-10143)
* only zonal listeners are actually accessed. for example:
    * az1: 9092, 10000, 10003, 10006, 10009 ... 10141
    * az2: 9092, 10001, 10004, 10007, 10010 ... 10142
    * az3: 9092, 10002, 10005, 10008, 10011 ... 10143

Continue broker mappings as follows:
    az1-a: bootstrap, broker 0 /6/12/18 ... 138 (max 25 listeners)
    az1-b: bootstrap, broker 1 /7/13/19 ... 139 (max 25 listeners)
    az2-a: bootstrap, broker 2 /8/14/20 ... 140 (max 25 listeners)
    az2-b: bootstrap, broker 3 /9/15/21 ... 141 (max 25 listeners)
    az3-a: bootstrap, broker 4/10/16/22 ... 142 (max 25 listeners)
    az3-b: bootstrap, broker 5/11/17/23 ... 143 (max 25 listeners)

```
./kafka-proxy server \
    --tls-enable \
    --bootstrap-server-mapping "pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9092,kafka.customer.domain:9092" \
    --bootstrap-server-mapping "b0-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9100,kafka-az1-a.customer.domain:9100" \
    --bootstrap-server-mapping "b1-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9101,kafka-az2-a.customer.domain:9101" \
    --bootstrap-server-mapping "b2-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9102,kafka-az3-a.customer.domain:9102" \
    --bootstrap-server-mapping "b3-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9103,kafka-az1-b.customer.domain:9103" \
    --bootstrap-server-mapping "b4-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9104,kafka-az2-b.customer.domain:9104" \
    --bootstrap-server-mapping "b5-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9105,kafka-az3-b.customer.domain:9105" \
    --bootstrap-server-mapping "b6-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9106,kafka-az1-a.customer.domain:9106" \
    --bootstrap-server-mapping "b7-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9107,kafka-az2-a.customer.domain:9107" \
    --bootstrap-server-mapping "b8-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9108,kafka-az3-a.customer.domain:9108" \
    --bootstrap-server-mapping "b9-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9109,kafka-az1-b.customer.domain:9109" \
    --bootstrap-server-mapping "b10-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9110,kafka-az2-b.customer.domain:9110" \
    --bootstrap-server-mapping "b11-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9111,kafka-az3-b.customer.domain:9111" \
    ...
```