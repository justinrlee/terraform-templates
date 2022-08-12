#!/bin/bash

tee ~/.ansible.cfg <<-'EOF'
[defaults]
hash_behaviour=merge
callbacks_enabled = timer, profile_tasks, profile_roles
forks=20
host_key_checking = False

[ssh_connection]
ssh_args = -o StrictHostKeyChecking=no -o ControlMaster=auto -o ControlPersist=120s
EOF

docker run --rm -d -p 10389:10389 -p 10636:10636 rroemhild/test-openldap

ansible -i host.yaml -m ping all

bash cert_gen.sh

git clone --branch 7.1.3-post https://github.com/confluentinc/cp-ansible.git

cd cp-ansible
ansible-galaxy collection build
ansible-galaxy collection install confluent-platform-7.1.3.tar.gz
ansible-galaxy collection list

cd ..
echo "now run this:"
echo 'ansible-playbook -i host.yaml confluent.platform.all'
echo "or:"
echo 'ansible-playbook -i host.yaml confluent.platform.all --skip-tags package'
echo ""
