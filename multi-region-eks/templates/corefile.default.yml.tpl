apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        ready
        health
        kubernetes cluster.local in-addr.arpa ip6.arpa {
            pods insecure
            # upstream
            fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        forward . /etc/resolv.conf
        cache 10
        loop
        reload
        loadbalance
    }
