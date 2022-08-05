#!/bin/bash

set -e
set -x

mkdir -p run/inventory
terraform output -json inventory | yq -P e - > run/inventory/plain.yaml
terraform output -json inventory_bastion_ldap | yq -P e - > run/inventory/ldap.yaml

yq '. *= load("inventory/rbac-futurama-centos.yaml") | . *= load("run/inventory/ldap.yaml") | . *= load("inventory/skip-java.yaml")' run/inventory/plain.yaml > run/inventory/host.yaml
echo "Generated Inventory File: run/inventory/host.yaml"

BASTION=$(terraform output -json bastion | jq -r '.public_dns[0]')

scp -o StrictHostKeyChecking=accept-new run/inventory/host.yaml centos@${BASTION}:~
scp scripts/centos-pre/* centos@${BASTION}:~