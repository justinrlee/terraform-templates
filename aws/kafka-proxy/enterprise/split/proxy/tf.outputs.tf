output "proxy_bootstrap" {
    value = "${var.proxy_bootstrap}.${var.route_53_domain}:9092"
}

output "bootstrap_server" {
    value = var.bootstrap_server
}