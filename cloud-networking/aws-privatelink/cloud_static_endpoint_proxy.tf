# Todo: Decide whether to use one or three of these
resource "aws_eip" "nginx" {
  count = var.external_proxy ? 3 : 0
  vpc   = true
}