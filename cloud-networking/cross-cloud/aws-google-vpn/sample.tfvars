prefix = "justin-tf-vpn"

google_project_id = "my-project-123"
google_region     = "asia-southeast1"
google_network    = "justin"
google_cidr       = "10.148.0.0/16"

aws_vpc_id   = "vpc-abc123"
aws_vpc_cidr = "10.32.0.0/16"
aws_rtb_id   = "rtb-abc123"

aws_asn    = "64515"
google_asn = "64514"

tunnels = [
  { psk : "0123456789abcdef0123456789abcdef", cidr : "169.254.83.72/30", aws : "169.254.83.73", gcp : "169.254.83.74/30", ext_gwy_interface : 0, vpn_gwy_interface : 0 },
  { psk : "0123456789abcdef0123456789abcdef", cidr : "169.254.83.76/30", aws : "169.254.83.77", gcp : "169.254.83.78/30", ext_gwy_interface : 1, vpn_gwy_interface : 0 },
  { psk : "0123456789abcdef0123456789abcdef", cidr : "169.254.83.80/30", aws : "169.254.83.81", gcp : "169.254.83.82/30", ext_gwy_interface : 2, vpn_gwy_interface : 1 },
  { psk : "0123456789abcdef0123456789abcdef", cidr : "169.254.83.84/30", aws : "169.254.83.85", gcp : "169.254.83.86/30", ext_gwy_interface : 3, vpn_gwy_interface : 1 },
]