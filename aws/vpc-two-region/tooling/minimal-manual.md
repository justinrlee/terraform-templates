
```shell
sudo apt-get update && \
sudo apt-get install -y openjdk-17-jre-headless && \
curl -O http://packages.confluent.io/archive/7.7/confluent-7.7.1.tar.gz && \
tar -xzvf confluent-7.7.1.tar.gz && \
ln -s confluent-7.7.1 confluent && \
echo 'export PATH=${PATH}:/home/ubuntu/confluent/bin' >> ~/.bashrc && \
export PATH=${PATH}:/home/ubuntu/confluent/bin

export N1=ip-10-39-2-10.ap-southeast-1.compute.internal
export N2=ip-10-55-2-10.ap-southeast-2.compute.internal

tee mcombined.properties <<-EOF
node.id=1
broker.rack=ap-southeast-1

process.roles=broker,controller
controller.quorum.voters=1@${N1}:9093

listeners=BROKER://:9092,CONTROLLER://:9093
inter.broker.listener.name=BROKER
advertised.listeners=BROKER://${N1}:9092
controller.listener.names=CONTROLLER
listener.security.protocol.map=CONTROLLER:PLAINTEXT,BROKER:PLAINTEXT

log.dirs=/home/ubuntu/kafka

min.insync.replicas=1
replica.selector.class=org.apache.kafka.common.replica.RackAwareReplicaSelector
confluent.log.placement.constraints={"version":2,"replicas":[{"count":1,"constraints":{"rack":"ap-southeast-2"}},{"count":1,"constraints":{"rack":"ap-southeast-1"}}],"observerPromotionPolicy":"under-min-isr"}

num.replica.fetchers=1

replica.socket.receive.buffer.bytes=-1
socket.receive.buffer.bytes=-1
socket.send.buffer.bytes=-1

num.partitions=1
num.recovery.threads.per.data.dir=1

replication.factor=1
default.replication.factor=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
confluent.license.topic.replication.factor=1
confluent.metadata.topic.replication.factor=1
confluent.security.event.logger.exporter.kafka.topic.replicas=1
confluent.balancer.topic.replication.factor=1

log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000

group.initial.rebalance.delay.ms=0

confluent.balancer.enable=false
confluent.cluster.link.enable=false
confluent.telemetry.enabled=false
confluent.reporters.telemetry.auto.enable=false
EOF

kafka-storage format -t 16Fh_3D3SICp43gcGnLnqA -c mcombined.properties

```

```shell
export N1=ip-10-39-2-10.ap-southeast-1.compute.internal
export N2=ip-10-55-2-10.ap-southeast-2.compute.internal

sudo apt-get update && \
sudo apt-get install -y openjdk-17-jre-headless && \
curl -O http://packages.confluent.io/archive/7.7/confluent-7.7.1.tar.gz && \
tar -xzvf confluent-7.7.1.tar.gz && \
ln -s confluent-7.7.1 confluent && \
echo 'export PATH=${PATH}:/home/ubuntu/confluent/bin' >> ~/.bashrc && \
export PATH=${PATH}:/home/ubuntu/confluent/bin

export N1=ip-10-39-2-10.ap-southeast-1.compute.internal
export N2=ip-10-55-2-10.ap-southeast-2.compute.internal

tee mbroker.properties <<-EOF
node.id=2
broker.rack=ap-southeast-2

process.roles=broker
controller.quorum.voters=1@${N1}:9093

listeners=BROKER://:9092
inter.broker.listener.name=BROKER
advertised.listeners=BROKER://${N2}:9092
controller.listener.names=CONTROLLER
listener.security.protocol.map=CONTROLLER:PLAINTEXT,BROKER:PLAINTEXT

log.dirs=/home/ubuntu/kafka

min.insync.replicas=1
replica.selector.class=org.apache.kafka.common.replica.RackAwareReplicaSelector
confluent.log.placement.constraints={"version":2,"replicas":[{"count":1,"constraints":{"rack":"ap-southeast-2"}},{"count":1,"constraints":{"rack":"ap-southeast-1"}}],"observerPromotionPolicy":"under-min-isr"}

num.replica.fetchers=1

replica.socket.receive.buffer.bytes=-1
socket.receive.buffer.bytes=-1
socket.send.buffer.bytes=-1

num.partitions=1
num.recovery.threads.per.data.dir=1

replication.factor=1
default.replication.factor=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
confluent.license.topic.replication.factor=1
confluent.metadata.topic.replication.factor=1
confluent.security.event.logger.exporter.kafka.topic.replicas=1
confluent.balancer.topic.replication.factor=1

log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000

group.initial.rebalance.delay.ms=0

confluent.balancer.enable=false
confluent.cluster.link.enable=false
confluent.telemetry.enabled=false
confluent.reporters.telemetry.auto.enable=false
EOF


kafka-storage format -t 16Fh_3D3SICp43gcGnLnqA -c mbroker.properties
```