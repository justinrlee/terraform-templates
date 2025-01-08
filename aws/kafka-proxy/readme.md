# Kafka-Proxy for Confluent Cloud

This folder has two roughly-equivalent TF projects in it:
* A single shot TF template that deploys everything at once
* A 'split' TF template that breaks down deployment into prereqs, peering connection, and proxy

Expose a Confluent Cloud Peering Cluster on the Internet with AWS NLBs, using Kafka-Proxy

Does the following:
* Create an AWS VPC with three (3) AZs, with the following:
    * 1x IGW
    * 3x Public Subnets (for NLB)
    * 3x Private Subnets (for Kafka-Proxy)
    * NAT Gateway for each private subnet
* In each AZ, create the following:
    * 1x NLB (3 total)
    * 49 NLB TLS listeners for each NLB (49 per AZ, 147 total)
        * 1x bootstrap listener (9092)
        * 48x broker listeners
    * 1x target group for each listenre (49 per AZ, 147 total)
    * ASG with EC2 instances running kafka-proxy
* Each NLB is responsible for 48 brokers (supports 144 total brokers, i.e. 192 CKU ultra cluster)

kafka-proxy is configured as follows:
* TLS termination in front of kafka-proxy (on NLB)
* TLS initiation to backend Kafka cluster

Comments:
* Requires an ACM certificate matching a Route53 public hosted zone (in this example, we're using a certificate with `*.confluent.justinrlee.io` in public hosted zone `confluent.justinrlee.io`)
* Peering connection between Confluent VPC and customer VPC has to be set up out-of-band. `vpc-peering-route.tf` has sample TF to set up the routing to a pre-existing pcx, but this is not fully automated
* Kafka-Proxy remaps advertised listeners, as follows:
    * Each broker gets a unique port (e.g. broker 0 is port 10000, broker 1 is 10001)
    * Advertised hostnames are mapped to the AZ that the broker exists in (e.g. if broker 0 is in apse1-az1, it'll be exposed by an NLB in apse1-az1)

kafka-proxy instances all have identical configurations:

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

Kafka-Proxy will be started via a userdata that downloads the kafka-proxy binary and starts it with a script that looks roughly like this:

```shell
./kafka-proxy server \
    --tls-enable \
    --bootstrap-server-mapping "pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:9092,kafka.customer.domain:9092" \
    --bootstrap-server-mapping "b0-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10000,kafka-az1.customer.domain:10000" \
    --bootstrap-server-mapping "b1-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10001,kafka-az2.customer.domain:10001" \
    --bootstrap-server-mapping "b2-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10002,kafka-az3.customer.domain:10002" \
    --bootstrap-server-mapping "b3-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10003,kafka-az1.customer.domain:10003" \
    --bootstrap-server-mapping "b4-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10004,kafka-az2.customer.domain:10004" \
    --bootstrap-server-mapping "b5-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10005,kafka-az3.customer.domain:10005" \
    --bootstrap-server-mapping "b6-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10006,kafka-az1.customer.domain:10006" \
    --bootstrap-server-mapping "b7-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10007,kafka-az2.customer.domain:10007" \
    --bootstrap-server-mapping "b8-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10008,kafka-az3.customer.domain:10008" \
    ... \
    --bootstrap-server-mapping "b141-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10008,kafka-az1.customer.domain:10141" \
    --bootstrap-server-mapping "b142-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10008,kafka-az2.customer.domain:10142" \
    --bootstrap-server-mapping "b143-pkc-vrzrj5.ap-southeast-1.aws.confluent.cloud:9092,0.0.0.0:10008,kafka-az3.customer.domain:10143"
```

![kafka-proxy v2 - 1nlb](https://github.com/user-attachments/assets/415928f5-ae7d-48c9-b9e8-ed650dd56b5b)
