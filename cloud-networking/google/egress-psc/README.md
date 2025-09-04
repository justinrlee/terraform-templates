# Google "Egress Private Services Connect" (Confluent Cloud managed connectors for data source/sink outside of Google)

This Terraform template provides an example of how to expose a single TCP-based data source/sink running outside of Google (but in a private network) to a fully-managed connector in Confluent Cloud (when using a Google PSC cluster)

To publish a PSC service, you first create a Google Network Load Balancer and then publish the NLB as a PSC Service. From a moderate amount of testing, there are only certain combinations of load balancer types that actually work to expose services running _outside_ of Google (you have many more options if your service is running in Google).

Internal Regional Proxy Network Load Balancer
* Must be an NLB (ALBs only support HTTP(S))
* Must be a Proxy Load Balancer (passthrough only works with services running on Google)
* Must be internal (not external)
* Must be regional (doesn't work with cross-region)
* Need Hybrid Network Endpoint Groups (NEGs)

This assumes you have already wired your Google VPC up to the network where your data source/sink lives. See [AWS Google VPN](../../cross-cloud/aws-google-vpn/) for an example of how to do this with AWS.

Deploys in these steps:
* Load Balancer
    * Proxy Subnetwork (only create this if your VPC doesn't already have this; this is where Google runs an Envoy layer)
    * 1x per AZ: Network Endpoint Group (NEG)
    * 1x per AZ: NEG Endpoint (pointing at the external data source/sink)
    * Health Check
    * Regional Backend Service, configured with the NEGs (basically, the 'backend' of the load balancer)
    * TCP Proxy
    * Reserved (private) IP address, for the internal load balancer
    * Forwarding rule (basically, the 'frontend' of the load balancer)
* Private Service Connect Service Attachment (publishes the service)
    * PSC Subnetwork (pool of IP addresses used as NAT addresses for clients coming in through the PSC)
    * PSC Service Attachment

Note: as far as I can tell, because of the unique combination of compatible services necessary to wire this up to a non-Google data source/sink, you need a separate PSC (and forwarding rule) for each backend you're trying to point to.
* The exception to this is if you're okay running your own reverse proxy and doing SNI routing based on the destination DNS name; this only works if your service is TLS-based (and the underlying Connector supports TLS)