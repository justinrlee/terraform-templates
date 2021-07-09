
output "private_dns" {
    value = [
        aws_instance.instance_r0s.*.private_dns,
        aws_instance.instance_r1s.*.private_dns,
        aws_instance.instance_r2s.*.private_dns,
    ]
}

output "label" {
    value = var.label
}