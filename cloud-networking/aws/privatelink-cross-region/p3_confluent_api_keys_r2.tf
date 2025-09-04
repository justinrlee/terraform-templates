# Service Account for Replicator running in R2
resource "confluent_service_account" "r2" {
  display_name = "${var.environment_name}-${var.r2.region}"
  description  = "Service Account for Replicator"

  provider = confluent.r2
}

# Permission for Replicator running in R2: CCA on local
resource "confluent_role_binding" "sa2_r2" {
  principal   = "User:${confluent_service_account.r2.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.r2.rbac_crn

  provider = confluent.r2
}

# Permission for Replicator running in R2: CCA on remote
resource "confluent_role_binding" "sa2_r1" {
  principal   = "User:${confluent_service_account.r2.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.r1.rbac_crn

  provider = confluent.r2
}

# API key for R2 Replicator to access local
resource "confluent_api_key" "sa2_r2" {
  display_name = "${var.environment_name}-${var.r2.region}-replicator-${confluent_kafka_cluster.r2.id}"
  description  = "Replicator in ${var.r2.region} talking to cluster ${confluent_kafka_cluster.r2.id} in ${var.r2.region}"

  disable_wait_for_ready = true
  
  owner {
    id          = confluent_service_account.r2.id
    api_version = confluent_service_account.r2.api_version
    kind        = confluent_service_account.r2.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.r2.id
    api_version = confluent_kafka_cluster.r2.api_version
    kind        = confluent_kafka_cluster.r2.kind

    environment {
      id = confluent_environment.r2.id
    }
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# API key for R2 Replicator to access remote
resource "confluent_api_key" "sa2_r1" {
  display_name = "${var.environment_name}-${var.r2.region}-replicator-${confluent_kafka_cluster.r1.id}"
  description  = "Replicator in ${var.r2.region} talking to cluster ${confluent_kafka_cluster.r1.id} in ${var.r1.region}"

  disable_wait_for_ready = true

  owner {
    id          = confluent_service_account.r2.id
    api_version = confluent_service_account.r2.api_version
    kind        = confluent_service_account.r2.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.r1.id
    api_version = confluent_kafka_cluster.r1.api_version
    kind        = confluent_kafka_cluster.r1.kind

    environment {
      id = confluent_environment.r1.id
    }
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}