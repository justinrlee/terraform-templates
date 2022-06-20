#!/bin/bash -ex

sudo apt-get update -y

sudo apt-get install -y python3-pip

sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install ansible

