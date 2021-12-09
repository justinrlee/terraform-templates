resource "local_file" "zookeeper" {
  count = 3

  filename = "run/${var.regions_short[count.index]}-zookeeper.yml"

  content = templatefile(
    "${path.module}/templates/zookeeper.yml.tpl",
    {
      index = count.index,
      namespaces = local.namespaces,
      offsets = var.zookeeper_offsets,
      counts = var.zookeeper_counts,
    }
  )
}
