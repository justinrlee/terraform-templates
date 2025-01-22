
locals {
    x = tolist([
  "apse1-az2",
  "apse1-az1",
  "apse1-az3",
])

}

output "x" {
    value = [for i in local.x: i]
}