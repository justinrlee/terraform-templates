environment_name = "justinlee-psc"
owner            = "justinlee"

google_project = "sales-engineering-206314"

regions = {
  "us-east1" = {
    cidr = "10.161.0.0/16"
    zones = [
      "us-east1-b",
      "us-east1-c",
      "us-east1-d",
    ]
  },
  "us-east4" = {
    cidr = "10.164.0.0/16"
    zones = [
      "us-east4-a",
      "us-east4-b",
      "us-east4-c",
    ]
  },
}