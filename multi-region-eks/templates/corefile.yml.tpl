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
    ${ns1}.svc.cluster.local:53 {
        log
        errors
        ready
        cache 10
        forward . ${ns1_ip1} ${ns1_ip2} {
            force_tcp
        }
    }
    ${ns2}.svc.cluster.local:53 {
        log
        errors
        ready
        cache 10
        forward . ${ns2_ip1} ${ns2_ip2} {
            force_tcp
        }
    }