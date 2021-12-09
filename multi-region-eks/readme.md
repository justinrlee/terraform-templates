kubectl --kubeconfig kubeconfig_justin-mrc-eks-use1 apply -f run/use1-corefile.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-use2 apply -f run/use2-corefile.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-usw2 apply -f run/usw2-corefile.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-use1 apply -f run/use1-zookeeper.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-use2 apply -f run/use2-zookeeper.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-usw2 apply -f run/usw2-zookeeper.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-use1 apply -f run/use1-kafka.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-use2 apply -f run/use2-kafka.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-usw2 apply -f run/usw2-kafka.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-use1 apply -f run/use1-observer.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-use2 apply -f run/use2-observer.yml

kubectl --kubeconfig kubeconfig_justin-mrc-eks-usw2 apply -f run/usw2-observer.yml