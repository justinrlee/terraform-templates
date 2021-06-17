output "bastion" {
    value = {
        public_ip = aws_instance.bastion.public_ip,
        private_ip = aws_instance.bastion.private_ip,
        public_dns = aws_instance.bastion.public_dns,
        private_dns = aws_instance.bastion.private_dns,
    }
}

output "zookeeper_use1" {
    value = {
        public_ip = aws_instance.zk_use1.public_ip
        private_ip = aws_instance.zk_use1.private_ip
        public_dns = aws_instance.zk_use1.public_dns
        private_dns = aws_instance.zk_use1.private_dns
    }
}

output "zookeeper_use2" {
    value = {
        public_ip = aws_instance.zk_use2.public_ip
        private_ip = aws_instance.zk_use2.private_ip
        public_dns = aws_instance.zk_use2.public_dns
        private_dns = aws_instance.zk_use2.private_dns
    }
}

output "zookeeper_usw2" {
    value = {
        public_ip = aws_instance.zk_usw2.public_ip
        private_ip = aws_instance.zk_usw2.private_ip
        public_dns = aws_instance.zk_usw2.public_dns
        private_dns = aws_instance.zk_usw2.private_dns
    }
}

output "brokers_use1" {
    value = {
        public_ip = aws_instance.broker_use1.*.public_ip
        private_ip = aws_instance.broker_use1.*.private_ip
        public_dns = aws_instance.broker_use1.*.public_dns
        private_dns = aws_instance.broker_use1.*.private_dns
    }
}

output "brokers_use2" {
    value = {
        public_ip = aws_instance.broker_use2.*.public_ip
        private_ip = aws_instance.broker_use2.*.private_ip
        public_dns = aws_instance.broker_use2.*.public_dns
        private_dns = aws_instance.broker_use2.*.private_dns
    }
}