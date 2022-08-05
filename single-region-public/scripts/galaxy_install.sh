#!/bin/bash

git clone --branch 7.1.1-post https://github.com/confluentinc/cp-ansible.git

cd cp-ansible
ansible-galaxy collection build
ansible-galaxy collection install confluent-platform-7.1.1.tar.gz
ansible-galaxy collection list

cd ..
ansible-playbook -i host.yaml confluent.platform.all