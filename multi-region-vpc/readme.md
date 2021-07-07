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