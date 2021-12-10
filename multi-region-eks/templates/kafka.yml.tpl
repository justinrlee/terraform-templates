---
apiVersion: platform.confluent.io/v1beta1
kind: Kafka
metadata:
  name: ${name}
  namespace: ${namespaces[index]}
  annotations:
    platform.confluent.io/broker-id-offset: "${offsets[index]}"
spec:
  replicas: ${counts[index]}
  image:
    application: confluentinc/cp-server:7.0.0
    init: confluentinc/confluent-init-container:2.2.0
  dataVolumeCapacity: 50Gi
  # Use override for rack awareness, to support observers
  # rackAssignment:
  #   nodeLabels:
  #   - topology.kubernetes.io/zone
  configOverrides:
    server:
    - replica.selector.class=org.apache.kafka.common.replica.RackAwareReplicaSelector
    - broker.rack=${rack}
    - zookeeper.connect=${zookeeper_connect}