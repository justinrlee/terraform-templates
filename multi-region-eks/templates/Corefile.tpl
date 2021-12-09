.:53 {
    errors
    ready
    health
    kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        upstream
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
    forward . ${ns1_lb} {
        force_tcp
    }
}
${ns2}.svc.cluster.local:53 {
    log
    errors
    ready
    cache 10
    forward . ${ns2_lb} {
        force_tcp
    }
}