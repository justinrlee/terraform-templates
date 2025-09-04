# Todo: Decide whether to use one or three of these
resource "aws_eip" "nginx_nlb" {
  count = var.external_nginx_nlb ? 3 : 0
  vpc   = true
}

# Primarily for destroy, but puts a time gap between Elastic IP creation and NLB creation
resource "time_sleep" "nginx_nlb" {
  count = var.external_nginx_nlb ? 1 : 0

  depends_on = [
    aws_eip.nginx_nlb
  ]

  create_duration = "5m"
  destroy_duration = "5m"

}