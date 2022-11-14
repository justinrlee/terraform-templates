# Todo: Decide whether to use one or three of these
resource "aws_eip" "dns" {
  count = var.external_dns ? 3 : 0
  vpc   = true
}
