

output "zz_jump_box" {
  # value = google_compute_instance.default[*]
  value = aws_instance.bastion[*].public_dns
  # sensitive = true
}

output "bootstrap_server" {
  value = var.dedicated_cluster ? confluent_kafka_cluster.dedicated[0].bootstrap_endpoint : null
}

output "nginx_nlb_endpoint" {
  value = aws_eip.nginx_nlb[*].public_ip
}

output "coredns_nlb_endpoint" {
  value = aws_eip.coredns_nlb[*].public_ip
}