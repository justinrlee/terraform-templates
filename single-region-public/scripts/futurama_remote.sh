#!/bin/bash

set -e
set -x

bash prereq.sh

ansible -i host.yaml -m ping all

bash cert_gen.sh

bash galaxy_install.sh