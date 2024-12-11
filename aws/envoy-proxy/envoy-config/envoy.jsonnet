// INPUTS
local bootstrap_server = "pkc-3rom2w.ap-southeast-1.aws.confluent.cloud";
local bootstrap_endpoint = "kafka-apse1.confluent.justinrlee.io";
local zonal_endpoints = [
    "kafka-apse1-az1.confluent.justinrlee.io",
    "kafka-apse1-az2.confluent.justinrlee.io",
    "kafka-apse1-az3.confluent.justinrlee.io"
];

local listener_address = "0.0.0.0";
local listener_bootstrap_port = 9092;
local listener_broker_port_offset = 10000;
local broker_count = 144;

/// Functions

// Listener kafka filter contains a remap for every broker id
local listener_kafka_filter() = {
    name: "envoy.filters.network.kafka_broker",
    typed_config: {
        "@type": "type.googleapis.com/envoy.extensions.filters.network.kafka_broker.v3.KafkaBroker",
        "stat_prefix": "listener",
        "id_based_broker_address_rewrite_spec": {
            rules: [
                {
                    id: i,
                    host: zonal_endpoints[i % 3],
                    port: listener_broker_port_offset + i,
                } for i in std.range(0, broker_count - 1)
            ]
        }
    }
};

// Listener tcp proxy filter to forward to matching cluster
local listener_tcp_proxy_filter(target_cluster) = {
    "name": "envoy.filters.network.tcp_proxy",
    "typed_config": {
        "@type": "type.googleapis.com/envoy.extensions.filters.network.tcp_proxy.v3.TcpProxy",
        "stat_prefix": "tcp",
        "cluster": target_cluster
    }
};

// Listens on a port, does broker remapping using kafka_filter, forwards to target (upstream) cluster
// TLS is optional (depending on whether TLS is terminated in front of Envoy)
local listener_stanza(port, target_cluster, tls) = {
    address: {
        socket_address: {
            address: listener_address,
            port_value: port,
        }
    },
    filter_chains: [
        {
            filters: [ listener_kafka_filter(), listener_tcp_proxy_filter(target_cluster) ],
            [if tls then "transport_socket"]: {
            "name": "envoy.transport_sockets.tls",
            "typed_config": {
                "@type": "type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.DownstreamTlsContext",
                "common_tls_context": {
                "tls_certificates": [
                    {
                    "certificate_chain": {
                        "filename": "certs/server.crt"
                    },
                    "private_key": {
                        "filename": "certs/server.key"
                    }
                    }
                ]
                }
            }
            }
        }
    ]
};

# Forwards to some upstream broker (or bootstrap)
local cluster_upstream_stanza(broker, tls) = {
    "name": broker,
    "connect_timeout": "0.25s",
    "type": "strict_dns",
    "lb_policy": "round_robin",
    "load_assignment": {
        "cluster_name": broker,
        "endpoints": [
        {
            "lb_endpoints": [
            {
                "endpoint": {
                "address": {
                    "socket_address": {
                    "address": broker,
                    "port_value": 9092
                    }
                }
                }
            }
            ]
        }
        ]
    },
    [if tls then "transport_socket"]: {
        "name": "envoy.transport_sockets.tls",
        "typed_config": {
            "@type": "type.googleapis.com/envoy.extensions.transport_sockets.tls.v3.UpstreamTlsContext",
            "sni": broker,
            "common_tls_context": {
                "validation_context": {
                    "match_typed_subject_alt_names": [
                        {
                        "san_type": "DNS",
                        "matcher": {
                            "exact": broker
                        }
                        }
                    ],
                    "trusted_ca": {
                        // Default on Debian-based systems
                        "filename": "/etc/ssl/certs/ca-certificates.crt"
                    }
                }
            }
        }
    }
};


{
    static_resources: {
        listeners:
            // Static bootstrap listener, plus one listener per broker
            [ listener_stanza(listener_bootstrap_port, bootstrap_server, false) ]
            + [ listener_stanza(listener_broker_port_offset + b, "b" + b + "-" + bootstrap_server, false) for b in std.range(0, broker_count - 1) ],
        clusters:
            // Static bootstrap upstream cluster, plus one upstream cluster per broker
            [ cluster_upstream_stanza(bootstrap_server, true) ]
            + [ cluster_upstream_stanza("b" + b + "-" + bootstrap_server, true) for b in std.range(0, broker_count - 1) ],
    },
}