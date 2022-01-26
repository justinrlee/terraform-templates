output "bastion" {
    value = {
        public_ip = aws_instance.bastions.*.public_ip,
        private_ip = aws_instance.bastions.*.private_ip,
        public_dns = aws_instance.bastions.*.public_dns,
        private_dns = aws_instance.bastions.*.private_dns,
    }
}

output "zookeepers" {
    value = {
        public_ip = aws_instance.zookeepers.*.public_ip
        private_ip = aws_instance.zookeepers.*.private_ip
        public_dns = aws_instance.zookeepers.*.public_dns
        private_dns = aws_instance.zookeepers.*.private_dns
    }
}

output "brokers" {
    value = {
        public_ip = aws_instance.brokers.*.public_ip
        private_ip = aws_instance.brokers.*.private_ip
        public_dns = aws_instance.brokers.*.public_dns
        private_dns = aws_instance.brokers.*.private_dns
    }
}

output "all_private_dns" {
    value = concat(
        aws_instance.bastions.*.private_dns,
        aws_instance.zookeepers.*.private_dns,
        aws_instance.brokers.*.private_dns,
        aws_instance.schema_registries.*.private_dns,
        aws_instance.control_centers.*.private_dns,
    )
}

output "all_brokers_dns" {
    value = concat(
        aws_instance.brokers.*.private_dns,
    )
}