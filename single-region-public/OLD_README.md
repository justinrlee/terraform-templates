TODO: Document

TODO: manual certificate generation

# Generate inventory

```bash
terraform output -json inventory | yq -P e - > run/inventory.yaml
terraform output -json inventory_bastion_ldap | yq -P e - > run/ldap.yaml

yq '. *= load("inventory/rbac-futurama.yaml") | . *= load("run/ldap.yaml")' run/inventory.yaml
```

# CentOS Setup
```bash
ssh -At centos@<bastion>
```

```bash

sudo yum update -y \
  && sudo yum install python3-pip git -y \
  && sudo python3 -m pip install --upgrade pip \
  && sudo python3 -m pip install ansible

```

On bastion: install LDAP

```bash
sudo yum install -y yum-utils

sudo yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io openldap-clients java-11-openjdk git

sudo systemctl enable docker; sudo systemctl start docker

sudo usermod -aG docker centos

sudo docker run --rm -d -p 10389:10389 -p 10636:10636 rroemhild/test-openldap
```

Create the host file: host.yml

do a ping (type yes as many times as necessary, run as many times as necessary)

```bash
ansible -i host.yml -m ping all
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
ansible-playbook -i host.yml confluent.platform.all
```

# Client stuff (from broker)

from c3:
```bash
keytool -list -keystore /var/ssl/private/control_center.truststore.jks

keytool -exportcert -alias caroot -keystore /var/ssl/private/control_center.truststore.jks -rfc > /root/ca.pem
```

```bash
/usr/local/bin/confluent login --url https://ip-10-9-1-147.ec2.internal:8090 --ca-cert-path /root/ca.pem
```

```properties
# client.properties
bootstrap.servers=ip-10-9-3-30.ec2.internal:9093
ssl.endpoint.identification.algorithm=https
ssl.truststore.location=/var/ssl/private/control_center.truststore.jks
ssl.truststore.password=confluent
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="professor" password="professor";

```

```bash
kafka-configs \
  --bootstrap-server <bootstrap-server>:9093 \
  --command-config client.properties \
  --alter \
  --topic _confluent-metadata-auth \
  --add-config segment.bytes=10485760
```