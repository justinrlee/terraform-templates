variable "namespace" {
    default = "kafka-proxy"
}

variable "image" {
    default = "justinrlee/kafka-proxy-3:3az-2025-01-21-a"
}

variable "replicas" {
    default = 2
}

variable "upstream_bootstrap" {
    default = "pkc-19jrjj.ap-southeast-1.aws.confluent.cloud:9092"
}

variable "regional_endpoint" {
    # default = "dedicated.apse1.confluent.justinrlee.io"
}

variable "zonal_endpoint" {
    # default = {
    #     "apse1-az1": "dedicated-apse1-az1.apse1.confluent.justinrlee.io",
    #     "apse1-az2": "dedicated-apse1-az2.apse1.confluent.justinrlee.io",
    #     "apse1-az3": "dedicated-apse1-az3.apse1.confluent.justinrlee.io",
    # }
}

variable "zones" {
    # default = [
    #     "apse1-az2",
    #     "apse1-az1",
    #     "apse1-az3",
    # ]
}

variable "target_groups" {}