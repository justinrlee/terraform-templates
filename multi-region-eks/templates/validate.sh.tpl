#!/bin/bash

kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[0]} -n confluent-${regions_short[0]} get all -owide

kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[1]} -n confluent-${regions_short[1]} get all -owide

kubectl --kubeconfig kubeconfig_${cluster_name}-${regions_short[2]} -n confluent-${regions_short[2]} get all -owide