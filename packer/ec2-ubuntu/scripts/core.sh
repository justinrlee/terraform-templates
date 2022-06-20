#!/bin/bash -ex

sudo apt-get update -y

sudo apt-get install -y \
  openjdk-11-jdk \
  git \
  ldap-utils \
  gnupg2 \
  apt-transport-https \
  openssl \
  unzip \

