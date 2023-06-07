environment_name = "justinlee-aws-privatelink"
owner            = "justinlee"
owner_email      = "jlee@confluent.io"

aws_account = "829250931565"

region = "us-east-1"
zones  = ["use1-az1", "use1-az2", "use1-az5"]
availability_zones = {
  "use1-az1" = {
    availability_zone_id = "use1-az1"
    cidr_block           = "10.1.0.0/24"
  },
  "use1-az2" = {
    availability_zone_id = "use1-az2"
    cidr_block           = "10.2.0.0/24"

  },
  "use1-az5" = {
    availability_zone_id = "use1-az5"
    cidr_block           = "10.5.0.0/24"
  }
}