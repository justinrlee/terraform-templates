# Credentials for Connect worker in R1
resource "kubernetes_secret" "connect_r1" {
  metadata {
    name      = "kafka-connect-worker"
    namespace = "confluent"
  }
  data = {
    "plain.txt" = templatefile("${path.module}/templates/plain.tftpl", {
      username = confluent_api_key.sa1_r1.id,
      password = confluent_api_key.sa1_r1.secret,
    })
  }

  provider = kubernetes.r1
}

# Credentials for Replicator in R1 to access local
resource "kubernetes_secret" "rep1_r1" {
  metadata {
    name      = "kafka-dst-plain"
    namespace = "confluent"
  }
  data = {
    "plain.txt" = templatefile("${path.module}/templates/plain_bootstrap.tftpl", {
      username = confluent_api_key.sa1_r1.id,
      password = confluent_api_key.sa1_r1.secret,
      bootstrap = confluent_kafka_cluster.r1.bootstrap_endpoint,
    })
  }

  provider = kubernetes.r1
}

# Credentials for Replicator in R1 to access remote
resource "kubernetes_secret" "rep1_r2" {
  metadata {
    name      = "kafka-src-plain"
    namespace = "confluent"
  }
  data = {
    "plain.txt" = templatefile("${path.module}/templates/plain_bootstrap.tftpl", {
      username = confluent_api_key.sa1_r2.id,
      password = confluent_api_key.sa1_r2.secret,
      bootstrap = confluent_kafka_cluster.r2.bootstrap_endpoint,
    })
  }

  provider = kubernetes.r1
}

# Connect worker for R1
# See ./reference/connect.yaml
resource "kubernetes_manifest" "r1" {
  manifest = {
    apiVersion = "platform.confluent.io/v1beta1"
    kind = "Connect"

    metadata = {
      name = "replicator"
      namespace = "confluent"
    }

    spec = {
      replicas = 3
      
      image = {
        application = "confluentinc/cp-enterprise-replicator:7.3.1"
        init = "confluentinc/confluent-init-container:2.5.0"
      }

      podTemplate = {
        envVars = [
          {
            name = "CLASSPATH",
            value = "/usr/share/java/kafka-connect-replicator/replicator-rest-extension-7.3.1.jar"
          }
        ]
      }

      configOverrides = {
        server = [
          "rest.extension.classes=io.confluent.connect.replicator.monitoring.ReplicatorMonitoringExtension"
        ]
      }

      dependencies = {
        kafka = {
          bootstrapEndpoint = confluent_kafka_cluster.r1.bootstrap_endpoint
          authentication = {
            type = "plain"
            jaasConfig = {
              secretRef = "kafka-connect-worker"
            }
          }
          tls = {
            enabled = "true"
            ignoreTrustStoreConfig = "true"
          }
        }
      }

      mountedSecrets = [
        {
          secretRef = "kafka-dst-plain"
        },
        {
          secretRef = "kafka-src-plain"
        },
      ]
    }
  }

  provider = kubernetes.r1
}

# Replicator Connector in R1
resource "kubernetes_manifest" "replicator_r1" {
  manifest = {
    apiVersion = "platform.confluent.io/v1beta1"
    kind = "Connector"

    metadata = {
      name = "replicator"
      namespace = "confluent"
    }

    spec = {
      name = "replicator"
      class = "io.confluent.connect.replicator.ReplicatorSourceConnector"
      taskMax = 6

      configs = {
        # We are replicating the topic from R2 to R1
        "topic.whitelist" = "${var.r2_topic}"
        "confluent.topic.replication.factor" = "3"
        "confluent.topic.sasl.mechanism" = "PLAIN"
        "confluent.topic.security.protocol" = "SASL_SSL"
        "dest.kafka.sasl.mechanism" = "PLAIN"
        "dest.kafka.security.protocol" = "SASL_SSL"
        "src.kafka.sasl.mechanism" = "PLAIN"
        "src.kafka.security.protocol" = "SASL_SSL"
        "key.converter" = "io.confluent.connect.replicator.util.ByteArrayConverter"
        "value.converter" = "io.confluent.connect.replicator.util.ByteArrayConverter"

        "confluent.topic.bootstrap.servers" = "$${file:/mnt/secrets/kafka-dst-plain/plain.txt:bootstrap}"
        "dest.kafka.bootstrap.servers" = "$${file:/mnt/secrets/kafka-dst-plain/plain.txt:bootstrap}"
        "src.kafka.bootstrap.servers" = "$${file:/mnt/secrets/kafka-src-plain/plain.txt:bootstrap}"
        "confluent.topic.sasl.jaas.config" = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$${file:/mnt/secrets/kafka-dst-plain/plain.txt:username}\" password=\"$${file:/mnt/secrets/kafka-dst-plain/plain.txt:password}\";"
        "dest.kafka.sasl.jaas.config" = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$${file:/mnt/secrets/kafka-dst-plain/plain.txt:username}\" password=\"$${file:/mnt/secrets/kafka-dst-plain/plain.txt:password}\";"
        "src.kafka.sasl.jaas.config" = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$${file:/mnt/secrets/kafka-src-plain/plain.txt:username}\" password=\"$${file:/mnt/secrets/kafka-src-plain/plain.txt:password}\";"
      }
    }
  }

  provider = kubernetes.r1
}