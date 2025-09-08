# Single Region VPC

Provisions a set of baseline resources in AWS, in a single region:
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

Takes the following as variable objects:
* Network configuration (desired availability zones)
* Instance configuration (number of instances in each public/private subnet)

## Example

The default tfvar file (terraform.tfvars) will create a single VPC with 10.38.0.0/16 in AWS ap-southeast-1, with 3 public subnets and 3 private subnets, with 2 EC2 instances in each public subnet.

```tf
environment_name = "justinrlee-one-region"

############################################################ R0
region_r0 = "ap-southeast-1"
prefix_r0 = "10.40"
region_short_r0 = "apse1"
zones_r0 = {
    "az1" = {
      "subnet" = 1,
      "az"     = "1a",
      "name"   = "ap-southeast-1a",
    },
    "az2" = {
      "subnet" = 2,
      "az"     = "1b",
      "name"   = "ap-southeast-1b",
    },
    "az3" = {
      "subnet" = 3,
      "az"     = "1c",
      "name"   = "ap-southeast-1c",
    },
  }
ec2_public_key_name_r0 = "justinrlee-confluent-dev"

instances_r0 = {
  "az1" = {
      public_count = 2,
      private_count = 0,
  },
  "az2" = {
      public_count = 2,
      private_count = 0,
  },
  "az3" = {
      public_count = 2,
      private_count = 0,
  },
}
```