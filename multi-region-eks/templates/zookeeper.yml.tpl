---
apiVersion: platform.confluent.io/v1beta1
kind: Zookeeper
metadata:
  name: zookeeper
  namespace: ${namespaces[index]}
  annotations:
    platform.confluent.io/zookeeper-myid-offset: "${offsets[index]}"
spec:
  replicas: ${counts[index]}
  image:
    application: confluentinc/cp-zookeeper:7.0.0
    init: confluentinc/confluent-init-container:2.2.0
  dataVolumeCapacity: 50Gi
  logVolumeCapacity: 10Gi
  configOverrides:
    peers:
%{ for i in range(0, counts[0]) ~}
    - server.${offsets[0] + i}=zookeeper-${i}.zookeeper.${namespaces[0]}.svc.cluster.local:2888:3888
%{ endfor ~}
%{ for i in range(0, counts[1]) ~}
    - server.${offsets[1] + i}=zookeeper-${i}.zookeeper.${namespaces[1]}.svc.cluster.local:2888:3888
%{ endfor ~}
%{ for i in range(0, counts[2]) ~}
    - server.${offsets[2] + i}=zookeeper-${i}.zookeeper.${namespaces[2]}.svc.cluster.local:2888:3888
%{ endfor ~}