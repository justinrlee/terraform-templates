resource "google_compute_external_vpn_gateway" "ext_gwy" {
  name            = "${var.prefix}-ext-vpn-gwy"
  redundancy_type = "FOUR_IPS_REDUNDANCY"

  interface {
    id = 0
    ip_address = aws_vpn_connection.vpn_conn[0].tunnel1_address
  }

  interface {
    id = 1
    ip_address = aws_vpn_connection.vpn_conn[0].tunnel2_address
  }

  interface {
    id = 2
    ip_address = aws_vpn_connection.vpn_conn[1].tunnel1_address
  }

  interface {
    id = 3
    ip_address = aws_vpn_connection.vpn_conn[1].tunnel2_address
  }
}


resource "google_compute_vpn_tunnel" "tunnel" {
  for_each = local.tunnels

  name                            = "${var.prefix}-tunnel-${each.key}"

  peer_external_gateway           = google_compute_external_vpn_gateway.ext_gwy.name
  peer_external_gateway_interface = each.value["ext_gwy_interface"]
  region                          = var.google_region
  ike_version                     = "2"
  
  shared_secret                   = each.value["psk"]
  router                          = google_compute_router.router.name
  vpn_gateway                     = google_compute_ha_vpn_gateway.gwy.id
  vpn_gateway_interface           = each.value["vpn_gwy_interface"]
}

resource "google_compute_router_interface" "interface" {
  for_each = local.tunnels

  router     = google_compute_router.router.name
  name       = "${var.prefix}-${each.key}-interface"
  region     = var.google_region
  ip_range   = each.value["gcp"]
  vpn_tunnel = google_compute_vpn_tunnel.tunnel[each.key].name
}

resource "google_compute_router_peer" "peer" {
  for_each = local.tunnels

  name            = "${var.prefix}-${each.key}-peer"
  interface       = google_compute_router_interface.interface[each.key].name
  peer_asn        = var.aws_asn
  # ip_address      = each.value["gcp"]
  peer_ip_address = each.value["aws"]
  router          = google_compute_router.router.name
  region          = var.google_region
}

output "tunnels" {
  value = {
    AWS_GW_0_TUNNEL_1____GOOGLE_0 = "[${local.tunnels["0-0"]["aws"]}/30] ${aws_vpn_connection.vpn_conn[0].tunnel1_address}  <> ${google_compute_ha_vpn_gateway.gwy.vpn_interfaces[0].ip_address} [${local.tunnels["0-0"]["gcp"]}]",
    AWS_GW_0_TUNNEL_2____GOOGLE_0 = "[${local.tunnels["0-1"]["aws"]}/30] ${aws_vpn_connection.vpn_conn[0].tunnel2_address}  <> ${google_compute_ha_vpn_gateway.gwy.vpn_interfaces[0].ip_address} [${local.tunnels["0-1"]["gcp"]}]",
    AWS_GW_1_TUNNEL_1____GOOGLE_1 = "[${local.tunnels["1-0"]["aws"]}/30] ${aws_vpn_connection.vpn_conn[1].tunnel1_address}  <> ${google_compute_ha_vpn_gateway.gwy.vpn_interfaces[1].ip_address} [${local.tunnels["1-0"]["gcp"]}]",
    AWS_GW_1_TUNNEL_2____GOOGLE_1 = "[${local.tunnels["1-1"]["aws"]}/30] ${aws_vpn_connection.vpn_conn[1].tunnel2_address}  <> ${google_compute_ha_vpn_gateway.gwy.vpn_interfaces[1].ip_address} [${local.tunnels["1-1"]["gcp"]}]",
  }
}