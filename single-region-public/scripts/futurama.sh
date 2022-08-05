#!/bin/bash

set -e
set -x

mkdir -p run
terraform output -json inventory | yq -P e - > run/inventory.yaml
terraform output -json inventory_bastion_ldap | yq -P e - > run/ldap.yaml

yq '. *= load("inventory/rbac-futurama.yaml") | . *= load("run/ldap.yaml")' run/inventory.yaml > run/host.yaml

BASTION=$(terraform output -json bastion | jq -r '.public_dns[0]')

scp run/host.yaml centos@${BASTION}:~

scp scripts/* centos@${BASTION}:~

ssh -At centos@${BASTION} "bash futurama_remote.sh"