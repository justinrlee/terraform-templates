# 2x aws customer gateway (for each IP on the google vpn gateway)
# 1x aws vpn gateway
#     1x vpn gateway attachment
# 2x aws vpn connections (each has local vpn gateway, 2x tunnels to single remote (customer) google gateway, 2x psk, 2x aws inside cidr)

locals {
  default_num_ha_vpn_interfaces = 2
}

resource "aws_vpn_gateway" "vpn_gw" {
  tags = {
    Name = "${var.prefix}-vpn-gw"
  }
  amazon_side_asn = var.aws_asn
}

resource "aws_vpn_gateway_attachment" "vpn_gateway_attachment" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gw.id
  vpc_id         = var.aws_vpc_id
}

resource "aws_customer_gateway" "gwy" {
  count = local.default_num_ha_vpn_interfaces

  device_name = "${var.prefix}-gwy-${count.index}"
  bgp_asn     = var.google_asn
  type        = "ipsec.1"
  ip_address  = google_compute_ha_vpn_gateway.gwy.vpn_interfaces[count.index]["ip_address"]

  tags = {
    Name = "${var.prefix}-gwy-${count.index}"
  }
}

resource "aws_vpn_connection" "vpn_conn" {
  count = local.num_tunnels / 2

  type = "ipsec.1"

  vpn_gateway_id        = aws_vpn_gateway.vpn_gw.id
  customer_gateway_id   = aws_customer_gateway.gwy[count.index % 2].id
  tunnel1_preshared_key = var.tunnels[2 * count.index]["psk"]
  tunnel1_inside_cidr   = var.tunnels[2 * count.index]["cidr"]
  tunnel2_preshared_key = var.tunnels[2 * count.index + 1]["psk"]
  tunnel2_inside_cidr   = var.tunnels[2 * count.index + 1]["cidr"]

  tags = {
    Name = "${var.prefix}-vpn-conn-${count.index}"
  }
}

output "aws_outside_ip_addresses" {
  value = {
    gw1_tunnel1 = aws_vpn_connection.vpn_conn[0].tunnel1_address,
    gw1_tunnel2 = aws_vpn_connection.vpn_conn[0].tunnel2_address,
    gw2_tunnel1 = aws_vpn_connection.vpn_conn[1].tunnel1_address,
    gw2_tunnel2 = aws_vpn_connection.vpn_conn[1].tunnel2_address,
  }
}