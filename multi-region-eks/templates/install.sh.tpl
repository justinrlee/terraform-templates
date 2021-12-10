#!/bin/bash

kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[0]} apply -f run/${regions_short[0]}-corefile.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[0]} apply -f run/${regions_short[0]}-zookeeper.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[0]} apply -f run/${regions_short[0]}-kafka.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[0]} apply -f run/${regions_short[0]}-observer.yml

kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[1]} apply -f run/${regions_short[1]}-corefile.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[1]} apply -f run/${regions_short[1]}-zookeeper.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[1]} apply -f run/${regions_short[1]}-kafka.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[1]} apply -f run/${regions_short[1]}-observer.yml

kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[2]} apply -f run/${regions_short[2]}-corefile.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[2]} apply -f run/${regions_short[2]}-kafka.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[2]} apply -f run/${regions_short[2]}-zookeeper.yml
kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[2]} apply -f run/${regions_short[2]}-observer.yml