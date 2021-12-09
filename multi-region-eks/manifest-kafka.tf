resource "local_file" "kafka" {
  count = 3

  filename = "run/${var.regions_short[count.index]}-kafka.yml"

  content = templatefile(
    "${path.module}/templates/kafka.yml.tpl",
    {
      name = "kafka",
      index = count.index,
      namespaces = local.namespaces,
      offsets = var.kafka_offsets,
      counts = var.kafka_counts,
      rack = var.regions[count.index]
    }
  )
}

resource "local_file" "observers" {
  count = 3

  filename = "run/${var.regions_short[count.index]}-observer.yml"

  content = templatefile(
    "${path.module}/templates/kafka.yml.tpl",
    {
      name = "observer",
      index = count.index,
      namespaces = local.namespaces,
      offsets = var.observer_offsets,
      counts = var.observer_counts,
      rack = "${var.regions[count.index]}-o"
    }
  )
}
