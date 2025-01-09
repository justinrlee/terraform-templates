output "proxy_bootstrap" {
    value = "${var.proxy_bootstrap}.${var.route_53_domain}"
}

output "bootstrap_server" {
    value = var.bootstrap_server
}