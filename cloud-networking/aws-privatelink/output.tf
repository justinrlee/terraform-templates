

output "zz_jump_box" {
  # value = google_compute_instance.default[*]
  value = aws_instance.bastion[*].public_dns
  # sensitive = true
}

output "bootstrap_server" {
  value = var.dedicated_cluster ? confluent_kafka_cluster.dedicated[0].bootstrap_endpoint : null
}

output "proxy_endpoint" {
  value = aws_eip.nginx[*].public_ip
}

output "dns_endpoint" {
  value = aws_eip.dns[*].public_ip
}