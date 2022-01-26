output "bastion" {
    value = {
        public_ip = aws_instance.bastion_r0s.*.public_ip,
        private_ip = aws_instance.bastion_r0s.*.private_ip,
        public_dns = aws_instance.bastion_r0s.*.public_dns,
        private_dns = aws_instance.bastion_r0s.*.private_dns,
    }
}

output "zookeepers" {
    value = {
        public_ip = aws_instance.zk_r0s.*.public_ip
        private_ip = aws_instance.zk_r0s.*.private_ip
        public_dns = aws_instance.zk_r0s.*.public_dns
        private_dns = aws_instance.zk_r0s.*.private_dns
    }
}

output "brokers" {
    value = {
        public_ip = aws_instance.brokers_r0s.*.public_ip
        private_ip = aws_instance.brokers_r0s.*.private_ip
        public_dns = aws_instance.brokers_r0s.*.public_dns
        private_dns = aws_instance.brokers_r0s.*.private_dns
    }
}

output "all_private_dns" {
    value = concat(
        aws_instance.bastion_r0s.*.private_dns,
        aws_instance.zk_r0s.*.private_dns,
        aws_instance.brokers_r0s.*.private_dns,
        aws_instance.schema_registry_r0s.*.private_dns,
        aws_instance.control_center_r0s.*.private_dns,
    )
}

output "all_brokers_dns" {
    value = concat(
        aws_instance.brokers_r0s.*.private_dns,
    )
}