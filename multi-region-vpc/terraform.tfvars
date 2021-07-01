# Default tfvars
cluster_name = "justin-mrc"
owner_name = "Justin Lee"

ec2_public_key_names = ["justinrlee-confluent-dev", "justinrlee-confluent-dev", "justinrlee-confluent-dev"]
prefixes = ["10.2", "10.18", "10.50"]


kafka_broker_custom_properties = {
    "confluent.log.placement.constraints": "{\"version\":2,\"replicas\":[{\"count\":2,\"constraints\":{\"rack\":\"us-east-1\"}},{\"count\":2,\"constraints\":{\"rack\":\"us-west-2\"}}],\"observers\":[{\"count\":1,\"constraints\":{\"rack\":\"us-east-1-o\"}},{\"count\":1,\"constraints\":{\"rack\":\"us-west-2-o\"}}], \"observerPromotionPolicy\": \"under-min-isr\"}"
    "min.insync.replicas": "3"
}


# Uncomment these to put zookeepers in public subnets (with public IPs)
# zookeeper_public_subnet = true
# zookeeper_public_ip = true

# Uncomment these to put brokers in public subnets (with public IPs)
# broker_public_subnet = true
# broker_public_ip = true

# public_listener_port = 9093