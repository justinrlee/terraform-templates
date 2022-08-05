# Ubuntu (Prebuilt)

```bash
# terraform apply -var-file var/ubuntu-rbac.tfvars
terraform apply -var-file var/ubuntu-rbac-pkg.tfvars
bash scripts/ubuntu-pre/local.sh
# bash scripts/centos-pre/local.sh
```

SSH in

```bash
bash prep.sh
```

```bash
# terraform apply -var-file var/ubuntu-rbac.tfvars
terraform apply -var-file var/ubuntu-rbac-pkg.tfvars
# bash scripts/ubuntu-pre/local.sh
bash scripts/centos-pre/local.sh
```

SSH in

```bash
bash prep.sh
```



# Generate inventory

```bash
terraform apply -var-file var/centos-rbac.tfvars

mkdir -p run
terraform output -json inventory | yq -P e - > run/inventory.yaml
terraform output -json inventory_bastion_ldap | yq -P e - > run/ldap.yaml

yq '. *= load("inventory/rbac-futurama.yaml") | . *= load("run/ldap.yaml")' run/inventory.yaml > run/host.yaml

BASTION=$(terraform output -json bastion | jq -r '.public_dns[0]')

scp run/host.yaml centos@${BASTION}:~/host.yaml
```

# CentOS Setup
```bash
terraform output bastion

scp scripts/* centos@ <...>
```

```bash
sudo yum update -y \
  && sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
  && sudo yum update -y \
  && sudo yum install -y \
    python3-pip \
    git \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    openldap-clients \
    java-11-openjdk \
    git \
  && sudo python3 -m pip install --upgrade pip \
  && sudo python3 -m pip install ansible \
  && sudo systemctl enable docker \
  && sudo systemctl start docker \
  && sudo usermod -aG docker centos \
  && sudo docker run --rm -d -p 10389:10389 -p 10636:10636 rroemhild/test-openldap


tee ~/.ansible.cfg <<-'EOF'
[defaults]
hash_behaviour=merge

[ssh_connection]
ssh_args = -o StrictHostKeyChecking=no
EOF
```

```bash
ansible -i host.yaml -m ping all
```

Then generate certs off the file

```bash
bash cert_gen.sh
```

# Install ansible collection

```bash
git clone --branch 7.0.3-post https://github.com/confluentinc/cp-ansible.git

cd cp-ansible
ansible-galaxy collection build
ansible-galaxy collection install confluent-platform-7.0.3.tar.gz
ansible-galaxy collection list

cd ..
ansible-playbook -i host.yaml confluent.platform.all
```

# Client stuff (from broker)

everything's in /usr/bin (on centos)

from c3:

```bash
keytool -list -keystore /var/ssl/private/control_center.truststore.jks

keytool -exportcert -alias caroot -keystore /var/ssl/private/control_center.truststore.jks -rfc > /root/ca.pem
```

```bash
/usr/local/bin/confluent login --url https://ip-10-9-3-30.ec2.internal:8090 --ca-cert-path /root/ca.pem
```

kafka client
```properties
bootstrap.servers=ip-10-9-3-30.ec2.internal:9093
ssl.endpoint.identification.algorithm=https
ssl.truststore.location=/var/ssl/private/kafka_broker.truststore.jks
# ssl.truststore.location=/var/ssl/private/control_center.truststore.jks
ssl.truststore.password=confluent
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="professor" password="professor";
```



Zookeeper client (brokers)

```bash
# JAAS config for digest
KAFKA_OPTS="-Djava.security.auth.login.config=/etc/kafka/kafka_server_jaas.conf" zookeeper-shell ip-10-9-1-52.ec2.internal:2182 -zk-tls-config-file /etc/kafka/zookeeper-tls-client.properties
```

Incomplete
```

/usr/bin/kafka-run-class \
-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty \
-Dzookeeper.ssl.trustStore.location=/var/ssl/private/zookeeper.truststore.jks \
-Dzookeeper.ssl.trustStore.password=confluent \
-Dzookeeper.ssl.keyStore.location=/var/ssl/private/zookeeper.keystore.jks \
-Dzookeeper.ssl.keyStore.password=confluent \
-Dzookeeper.client.secure=true \
org.apache.zookeeper.client.FourLetterWordMain $(hostname -f) 2182 srvr true

/usr/bin/kafka-run-class \
-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty \
-Dzookeeper.ssl.trustStore.location=/var/ssl/private/zookeeper.truststore.jks \
-Dzookeeper.ssl.trustStore.password=confluent \
-Dzookeeper.ssl.keyStore.location=/var/ssl/private/zookeeper.keystore.jks \
-Dzookeeper.ssl.keyStore.password=confluent \
-Dzookeeper.client.secure=true \
org.apache.zookeeper.client.FourLetterWordMain $(hostname -f) 2182 mntr true
```

```
kafka-add-brokers --bootstrap-server ip-10-9-1-144.ec2.internal:9093 --command-config client.properties --describe

kafka-remove-brokers --bootstrap-server ip-10-9-1-144.ec2.internal:9093 --command-config client.properties --describe
```

```
kafka-reassign-partitions --bootstrap-server ip-10-9-1-144.ec2.internal:9093 --command-config client.properties --list
kafka-replica-exclusions --bootstrap-server ip-10-9-1-144.ec2.internal:9093 --command-config client.properties --describe
```