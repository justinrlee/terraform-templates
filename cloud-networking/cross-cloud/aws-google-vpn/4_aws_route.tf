resource "aws_route" "vpn_route" {
    route_table_id = var.aws_rtb_id
    destination_cidr_block = var.google_cidr

    gateway_id = aws_vpn_gateway.vpn_gw.id
}