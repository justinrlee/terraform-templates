# Default tfvars
environment_name = "justin-tf-dev"
owner_name       = "Justin Lee"
owner_contact    = "jlee@confluent.io"
date_updated     = "2022-04-15"

ec2_public_key_name = "justinrlee-confluent-dev"
prefix              = "10.2"

bastion_counts = [1]

zookeeper_counts = [3]

# broker_counts = [ 1 ]
broker_counts = [4]

control_center_counts = [1]

schema_registry_counts = [2]

# connect_clusters = {
#   one = {
#     name          = "one"
#     counts        = [1]
#     instance_type = "t3.large"
#   }
# }

# ksqldb_clusters = {
#   one = {
#     name          = "one"
#     counts        = [1]
#     instance_type = "t3.large"
#   }
# }

# kafka_broker_custom_properties = {
#     "confluent.log.placement.constraints": "{\"version\":2,\"replicas\":[{\"count\":2,\"constraints\":{\"rack\":\"us-east-1\"}},{\"count\":2,\"constraints\":{\"rack\":\"us-west-2\"}}],\"observers\":[{\"count\":1,\"constraints\":{\"rack\":\"us-east-1-o\"}},{\"count\":1,\"constraints\":{\"rack\":\"us-west-2-o\"}}], \"observerPromotionPolicy\": \"under-min-isr\"}"
#     "min.insync.replicas": "3"
# }

# connect_clusters = {
#     "syslog" = {
#         name = "syslog"
#         counts = [2, 2, 0]
#         instance_type = "t3.large"
#     }
#     "elastic" = {
#         name = "elastic"
#         counts = [2, 2, 0]
#         instance_type = "t3.medium"
#     }
# }

# ksql_clusters = {
#     "ksql1" = {
#         name = "ksql1"
#         counts = [2, 2, 0]
#         instance_type = "t3.large"
#     }
#     "ksql2" = {
#         name = "ksql2"
#         counts = [2, 2, 0]
#         instance_type = "t3.medium"
#     }
# }