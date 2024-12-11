output "bastion" {
  value = "${aws_instance.bastion.public_dns} : ${aws_instance.bastion.private_dns}"
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "nlb_security_group_id" {
  value = aws_security_group.nlb.id
}

output "internal_security_group_id" {
  value = aws_security_group.allow_internal.id
}

output "zone_nlb_mappings" {
  value = {
    "az1" = aws_lb.az1.id,
    "az2" = aws_lb.az2.id,
    "az3" = aws_lb.az3.id,
  }
}

output "zone_private_subnet_mappings" {
  value = {
    for zone, subnet in aws_subnet.private:
      zone => subnet.id
  }
}

output "route_table_default" {
  value = aws_vpc.main.default_route_table_id
}

output "route_table_zone_mapping" {
  value = {
    for zone,route_table in aws_route_table.private_zonal:
      zone => route_table.id
  }
}

output "zone_eip_mappings" {
  value = {
    "az1" = aws_eip.az1.public_ip,
    "az2" = aws_eip.az2.public_ip,
    "az3" = aws_eip.az3.public_ip,
  }
}