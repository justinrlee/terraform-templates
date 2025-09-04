# Have to get a list of domain files, including the one that will be created by the above resource if it doesn't already exist
locals {
  domains =  setunion(
          toset(fileset("${path.module}/../_generated_dns", "*.cloud")), [confluent_network.network.dns_domain]
        , [confluent_network.network.dns_domain]
      )
}