output "bastion" {
    value = {
        public_ip = aws_instance.bastion_r0s.*.public_ip,
        private_ip = aws_instance.bastion_r0s.*.private_ip,
        public_dns = aws_instance.bastion_r0s.*.public_dns,
        private_dns = aws_instance.bastion_r0s.*.private_dns,
    }
}

output "zookeeper_r0s" {
    value = {
        public_ip = aws_instance.zk_r0s.*.public_ip
        private_ip = aws_instance.zk_r0s.*.private_ip
        public_dns = aws_instance.zk_r0s.*.public_dns
        private_dns = aws_instance.zk_r0s.*.private_dns
    }
}

output "zookeeper_r1s" {
    value = {
        public_ip = aws_instance.zk_r1s.*.public_ip
        private_ip = aws_instance.zk_r1s.*.private_ip
        public_dns = aws_instance.zk_r1s.*.public_dns
        private_dns = aws_instance.zk_r1s.*.private_dns
    }
}

output "zookeeper_r2s" {
    value = {
        public_ip = aws_instance.zk_r2s.*.public_ip
        private_ip = aws_instance.zk_r2s.*.private_ip
        public_dns = aws_instance.zk_r2s.*.public_dns
        private_dns = aws_instance.zk_r2s.*.private_dns
    }
}

output "brokers_r0s" {
    value = {
        public_ip = aws_instance.brokers_r0s.*.public_ip
        private_ip = aws_instance.brokers_r0s.*.private_ip
        public_dns = aws_instance.brokers_r0s.*.public_dns
        private_dns = aws_instance.brokers_r0s.*.private_dns
    }
}

output "brokers_r1s" {
    value = {
        public_ip = aws_instance.brokers_r1s.*.public_ip
        private_ip = aws_instance.brokers_r1s.*.private_ip
        public_dns = aws_instance.brokers_r1s.*.public_dns
        private_dns = aws_instance.brokers_r1s.*.private_dns
    }
}

output "all_private_dns" {
    value = concat(
        aws_instance.bastion_r0s.*.private_dns,
        aws_instance.zk_r0s.*.private_dns,
        aws_instance.zk_r1s.*.private_dns,
        aws_instance.zk_r2s.*.private_dns,
        aws_instance.brokers_r0s.*.private_dns,
        aws_instance.brokers_r1s.*.private_dns,
        aws_instance.brokers_r2s.*.private_dns,
        aws_instance.schema_registry_r0s.*.private_dns,
        aws_instance.schema_registry_r1s.*.private_dns,
        aws_instance.schema_registry_r2s.*.private_dns,
        aws_instance.control_center_r0s.*.private_dns,
        aws_instance.control_center_r1s.*.private_dns,
        aws_instance.control_center_r2s.*.private_dns,
    )
}

output "all_brokers_dns" {
    value = concat(
        aws_instance.brokers_r0s.*.private_dns,
        aws_instance.brokers_r1s.*.private_dns,
        aws_instance.brokers_r2s.*.private_dns,
    )
}