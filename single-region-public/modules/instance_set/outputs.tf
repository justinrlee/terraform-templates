
output "private_dns" {
    value = [
        aws_instance.instances.*.private_dns,
    ]
}

output "label" {
    value = var.label
}