# Two Region VPC

Does the same as one-region-vpc, except with two regions, which are also peered together.

Takes the following as variable objects:
* Per-Region network configuration (desired availability zones)
* Per-Region Instance configuration (number of instances in each public/private subnet)

## Resources

Per Region:
* VPC
* Internet gateway
* Default route (in default route table) pointing at IGW
* 2x Security Groups:
    * "Allow Internal" (Full access from everything in 10.0.0.0/8)
    * "Allow Home" (Full access from single IP address)
    * (default security group in VPC is untouched)
* Per AZ:
    * Public Subnet
    * Private Subnet
    * NAT Gateway
    * Route Table (attached to private subnet)
    * Default route for private route table, pointing at NAT Gateway
* EC2 instances in each subnet, as desired

Additionally:
* Peering connection between two VPCs
* Routes in all route tables pointing at the peering connection

## Example

The default tfvar file will create a two VPCs in ap-southeast-1 and ap-southeast-2, each with 3 public subnets and 3 private subnets, with 2 EC2 instances in each public subnet.

The two VPCs will also be peered together (with appropriate routes)
