resource "local_file" "install" {

  filename = "run.install.sh"

  content = templatefile(
    "${path.module}/templates/install.sh.tpl",
    {
      cluster_name = var.cluster_name,
      regions_short = var.regions_short,
    }
  )
}

resource "local_file" "uninstall" {

  filename = "run.uninstall.sh"

  content = templatefile(
    "${path.module}/templates/uninstall.sh.tpl",
    {
      cluster_name = var.cluster_name,
      regions_short = var.regions_short,
    }
  )
}

resource "local_file" "validate" {

  filename = "run.validate.sh"

  content = templatefile(
    "${path.module}/templates/validate.sh.tpl",
    {
      cluster_name = var.cluster_name,
      regions_short = var.regions_short,
    }
  )
}