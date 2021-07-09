# Multi-Region Confluent Platform

**THIS WILL CREATE MANY RESOURCES WHICH WILL COST MUCH MONEY**

Creates the infrastructure for a US-based AWS multi-region Confluent Platform cluster

Consists of the following:
* Three VPCs (us-east-1, us-east-2, us-west-2), each with:
    * Three public subnets
    * Three private subnets
    * One shared public route table
    * Three private route tables
    * NAT gateways everywhere
* Peering connections between the three VPCs, including:
    * Peering connection (automatically accepted)
    * DNS resolution turned on (bidirectional)
    * Route table entries for all

* Bastion host(s)
    * SG: 22 inbound from Internet
* Zookeepers
    * SG: All internal
* Brokers (primary)
    * SG: All internal, 9092 from Internet

For now, all internal traffic is allowed; may lock this down later

# cp-ansible inventory

If you have a fully deployed infrastructure, you can generate a cp-ansible-friendly YAML inventory with this command (note that currently, the log placement constraints bit is a hardcoded string from the default `terraform.tfvars`)

```bash
terraform output -json inventory | yq e -P -
```

You should get something like this:

```yml
all:
  vars:
    ansible_become: true
    ansible_connection: ssh
    ansible_user: ubuntu
    kafka_broker_custom_properties:
      confluent.log.placement.constraints: '{"version":2,"replicas":[{"count":2,"constraints":{"rack":"us-east-1"}},{"count":2,"constraints":{"rack":"us-west-2"}}],"observers":[{"count":1,"constraints":{"rack":"us-east-1-o"}},{"count":1,"constraints":{"rack":"us-west-2-o"}}], "observerPromotionPolicy": "under-min-isr"}'
      min.insync.replicas: "3"
      replica.selector.class: org.apache.kafka.common.replica.RackAwareReplicaSelector
    regenerate_ca: false
    ssl_enabled: true
    validate_hosts: false
control_center:
  hosts:
    ip-10-2-1-51.ec2.internal: null
kafka_broker:
  hosts:
    ip-10-18-101-22.us-east-2.compute.internal:
      broker_id: 203
      kafka_broker_custom_properties:
        broker.rack: us-east-2-o
    ip-10-18-101-62.us-east-2.compute.internal:
      broker_id: 200
      kafka_broker_custom_properties:
        broker.rack: us-east-2
    ip-10-18-102-92.us-east-2.compute.internal:
      broker_id: 201
      kafka_broker_custom_properties:
        broker.rack: us-east-2
    ip-10-18-103-251.us-east-2.compute.internal:
      broker_id: 202
      kafka_broker_custom_properties:
        broker.rack: us-east-2
    ip-10-2-101-15.ec2.internal:
      broker_id: 103
      kafka_broker_custom_properties:
        broker.rack: us-east-1-o
    ip-10-2-101-92.ec2.internal:
      broker_id: 100
      kafka_broker_custom_properties:
        broker.rack: us-east-1
    ip-10-2-102-17.ec2.internal:
      broker_id: 101
      kafka_broker_custom_properties:
        broker.rack: us-east-1
    ip-10-2-103-15.ec2.internal:
      broker_id: 102
      kafka_broker_custom_properties:
        broker.rack: us-east-1
schema_registry:
  hosts:
    ip-10-18-101-12.us-east-2.compute.internal: null
    ip-10-2-101-89.ec2.internal: null
zookeeper:
  hosts:
    ip-10-18-101-207.us-east-2.compute.internal: null
    ip-10-2-101-163.ec2.internal: null
    ip-10-50-101-150.us-west-2.compute.internal: null
```

# Very rough instructions (WIP, need more automation probably):

**Everything past here is super hacky**

1. Set your variables (`terraform.tfvars`); the most critical one is your ssh key, which should an array of ssh key ids for each region
1. `terraform plan`
1. `terraform apply`
1. `terraform output bastion` to get the bastion host dns
1. `terraform output -json all_private_dns | jq -r '.[]' > run.all_private_dns` to get list of all private dns names (requires jq), copy to bastion
1. `terraform output -json inventory | yq e -P - > hosts.yml` to get ansible inventory (requires yq), copy to bastion
1. Copy SSH key to the bastion host

Generate client file:
```bash
BOOTSTRAP=$(terraform output -json all_brokers_dns | jq -r '.[]' | sed 's|$|:9092|g' | tr '\n' ',' | sed 's|,$||g')

tee client.properties <<-EOF
bootstrap.servers=${BOOTSTRAP}
security.protocol=SSL
ssl.truststore.location=/home/ubuntu/truststore.jks
ssl.truststore.password=confluent
EOF
```

Copy it to the bastion host.

From bastion host:

1. Start ssh-agent: `eval $(ssh-agent)`
1. Add ssh key: `ssh-add key_name`
1. Trust all hosts: `for ip in $(cat run.all_private_dns); do ssh-keyscan -t ecdsa $ip >> ~/.ssh/known_hosts; done`

Install other stuff:
```bash
sudo apt-get update
sudo apt-add-repository --yes --update ppa:ansible/ansible

sudo apt-get install python3-pip software-properties-common ansible openjdk-11-jre-headless -y


git clone https://github.com/confluentinc/cp-ansible
cd cp-ansible
git checkout 6.2.0-post

cp ../hosts.yml .
```

1. run the ansible ping: `ansible -i hosts.yml all -m ping`
1. install everything: `ansible-playbook -i hosts.yml all.yml`

Set up client on bastion

```bash
# from home directory
cd ~

curl -O http://packages.confluent.io/archive/6.2/confluent-6.2.0.tar.gz
tar -xzvf confluent-6.2.0.tar.gz

ln -s confluent-6.2.0 confluent

keytool -import -file cp-ansible/generated_ssl_files/snakeoil-ca-1.crt -alias snakeoil -keystore truststore.jks -storepass confluent -noprompt
```

get (arbitrary) bootstrap from bastion:
```bash
BOOTSTRAP=$(grep bootstrap client.properties | awk -F',' '{print $2}')

./confluent/bin/kafka-topics --bootstrap-server ${BOOTSTRAP} --command-config ./client.properties --list
```

do other stuff to your heart's content

TODO:
* Clean up style
* Fix style for variables ("quotes" or not for variable names)
* Add Connect
* Add ksqlDB
* Add RP