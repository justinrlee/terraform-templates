# Multi-Region Confluent Platform

Creates the infrastructure for a US-based AWS multi-region Confluent Platform cluster

Consists of the following:
* Three VPCs (us-east-1, us-east-2, us-west-2), each with:
    * Three public subnets
    * Three private subnets
    * One shared public route table
    * Three private route tables
* Peering connections between the three VPCs, including:
    * Peering connection (automatically accepted)
    * DNS resolution turned on (bidirectional)
    * Route table entries for all

* Bastion host in us-east-1 (last public subnet)
    * SG: 22 inbound from Internet
* Three zookeepers (one in each region)
    * SG: All internal
* Three brokers in us-east-1 (one in each public subnet)
    * SG: All internal, 9092 from Internet

For now, all internal traffic is allowed; may lock this down later