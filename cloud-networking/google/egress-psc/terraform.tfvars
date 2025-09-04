google_project_id = "sales-engineering-206314"
google_region     = "asia-southeast1"
google_network    = "justin"
google_subnetwork = "justin"
google_zones       = {
    "asia-southeast1-a": {}, "asia-southeast1-b": {}
}

prefix = "justin-oracle-psc-mz"

proxy_subnet_cidr = "10.76.0.0/24"
load_balancer_ip  = "10.148.0.31"

target_ip   = "10.32.1.63"
target_port = 1521