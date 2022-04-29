TODO: Document

TODO: manual certificate generation

terraform output -json inventory | yq -P e - > run/inventory.yaml

yq '. *= load("inventories/rbac-futurama.yaml")' run/inventory.yaml