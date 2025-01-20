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

output "nlb_arn" {
  value = aws_lb.main.id
}

# output "zone_nlb_mappings" {
#   value = {
#     "az1" = aws_lb.az1.id,
#     "az2" = aws_lb.az2.id,
#     "az3" = aws_lb.az3.id,
#   }
# }

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
    for k,v in var.zones:
      k => aws_eip.nlb[k].public_ip
  }
}