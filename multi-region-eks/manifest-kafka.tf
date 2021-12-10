locals {
  zookeeper_connect = "zookeeper.${local.namespaces[0]}.svc.cluster.local:2181,zookeeper.${local.namespaces[1]}.svc.cluster.local:2181,zookeeper.${local.namespaces[2]}.svc.cluster.local:2181"
}

resource "local_file" "kafka" {
  count = 3

  filename = "run/${var.regions_short[count.index]}-kafka.yml"

  content = templatefile(
    "${path.module}/templates/kafka.yml.tpl",
    {
      namespaces = local.namespaces,
      zookeeper_connect = local.zookeeper_connect,
      index = count.index,

      name = "kafka",
      counts = var.kafka_counts,
      offsets = var.kafka_offsets,
      rack = var.regions[count.index],
    }
  )
}

resource "local_file" "observers" {
  count = 3

  filename = "run/${var.regions_short[count.index]}-observer.yml"

  content = templatefile(
    "${path.module}/templates/kafka.yml.tpl",
    {
      zookeeper_connect = local.zookeeper_connect,
      namespaces = local.namespaces,
      index = count.index,

      name = "observer",
      counts = var.observer_counts,
      offsets = var.observer_offsets,
      rack = "${var.regions[count.index]}-o"
    }
  )
}
