#!/bin/bash

kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[0]} apply -f run/default-corefile.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[0]} delete -f run/${regions_short[0]}-zookeeper.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[0]} delete -f run/${regions_short[0]}-kafka.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[0]} delete -f run/${regions_short[0]}-observer.yml

kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[1]} apply -f run/default-corefile.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[1]} delete -f run/${regions_short[1]}-zookeeper.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[1]} delete -f run/${regions_short[1]}-kafka.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[1]} delete -f run/${regions_short[1]}-observer.yml

kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[2]} apply -f run/default-corefile.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[2]} delete -f run/${regions_short[2]}-kafka.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[2]} delete -f run/${regions_short[2]}-zookeeper.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[2]} delete -f run/${regions_short[2]}-observer.yml