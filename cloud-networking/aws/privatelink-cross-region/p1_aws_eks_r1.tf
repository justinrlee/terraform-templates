
module "r1_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.environment_name
  cluster_version = var.eks_version

  vpc_id = aws_vpc.r1.id
  subnet_ids = [ for subnet in aws_subnet.r1: subnet.id ]

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      name = "default"

      min_size     = 3
      max_size     = 3
      desired_size = 3

      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"

      instance_types = [
        "t3.xlarge"
      ]
      # capacity_type  = "SPOT"
    }
  }

  # Necessary for AWS Load Balancer Controller to work properly
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    ingress_cluster_tcp = {
      description                   = "Cluster to node upper ports/protocols"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  tags = {
    owner_email = var.owner
    Terraform   = true
  }

  cluster_timeouts = {
    create = "60m",
    update = "60m",
    delete = "60m",
  }

  providers = {
    aws = aws.r1
  }
}