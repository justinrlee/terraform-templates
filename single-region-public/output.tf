output "bastion" {
  value = {
    public_ip   = aws_instance.bastions.*.public_ip,
    private_ip  = aws_instance.bastions.*.private_ip,
    public_dns  = aws_instance.bastions.*.public_dns,
    private_dns = aws_instance.bastions.*.private_dns,
  }
}

output "zookeepers" {
  value = {
    public_ip   = aws_instance.zookeepers.*.public_ip
    private_ip  = aws_instance.zookeepers.*.private_ip
    public_dns  = aws_instance.zookeepers.*.public_dns
    private_dns = aws_instance.zookeepers.*.private_dns
  }
}

output "brokers" {
  value = {
    public_ip   = aws_instance.brokers.*.public_ip
    private_ip  = aws_instance.brokers.*.private_ip
    public_dns  = aws_instance.brokers.*.public_dns
    private_dns = aws_instance.brokers.*.private_dns
  }
}


output "brokers_zone_a" {
  value = {
    public_ip   = aws_instance.brokers_zone_a.*.public_ip
    private_ip  = aws_instance.brokers_zone_a.*.private_ip
    public_dns  = aws_instance.brokers_zone_a.*.public_dns
    private_dns = aws_instance.brokers_zone_a.*.private_dns
  }
}

output "brokers_zone_b" {
  value = {
    public_ip   = aws_instance.brokers_zone_b.*.public_ip
    private_ip  = aws_instance.brokers_zone_b.*.private_ip
    public_dns  = aws_instance.brokers_zone_b.*.public_dns
    private_dns = aws_instance.brokers_zone_b.*.private_dns
  }
}

output "brokers_zone_c" {
  value = {
    public_ip   = aws_instance.brokers_zone_c.*.public_ip
    private_ip  = aws_instance.brokers_zone_c.*.private_ip
    public_dns  = aws_instance.brokers_zone_c.*.public_dns
    private_dns = aws_instance.brokers_zone_c.*.private_dns
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

# TODO: include zookeepers if binpacking
output "all_brokers_dns" {
  value = concat(
    aws_instance.brokers.*.private_dns,
    aws_instance.brokers_zone_a.*.private_dns,
    aws_instance.brokers_zone_b.*.private_dns,
    aws_instance.brokers_zone_c.*.private_dns,
  )
}