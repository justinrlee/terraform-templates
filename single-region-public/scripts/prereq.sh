#!/bin/bash

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