# Default tfvars
cluster_name = "justin-src"
owner_name = "Justin Lee"

ec2_public_key_names = ["justinrlee-confluent-dev", "justinrlee-confluent-dev", "justinrlee-confluent-dev"]
prefixes = ["10.2", "10.18", "10.50"]


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