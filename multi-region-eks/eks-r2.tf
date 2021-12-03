
data "aws_eks_cluster" "r2" {
  name = module.eks_cluster_r2.cluster_id

  provider = aws.r2a
}

data "aws_eks_cluster_auth" "r2" {
  name = module.eks_cluster_r2.cluster_id

  provider = aws.r2a
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.r2.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.r2.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.r2.token

  # experiments {
  #   manifest_resource = true
  # }

  alias = "eks_r2"
}

module "eks_cluster_r2" {
  source          = "github.com/terraform-aws-modules/terraform-aws-eks?ref=v17.24.0"
  cluster_name    = "${var.cluster_name}-${var.regions_short[2]}"
  cluster_version = "1.21"
  subnets = module.vpc_r2s.public_subnets

  vpc_id = module.vpc_r2s.vpc_id

  manage_aws_auth              = true
  manage_cluster_iam_resources = true
  manage_worker_iam_resources  = true

  worker_create_security_group                       = true
  worker_create_cluster_primary_security_group_rules = true

  write_kubeconfig = true

  map_roles = [
    {
      rolearn  = aws_iam_role.worker_role.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]

  # Todo: figure out how to set up security groups for managed nodes
  # node_groups_defaults = {
  #   ami_type  = "AL2_x86_64"
  #   disk_size = 50
  # }

  # node_groups = {
  #   example = {
  #     desired_capacity = 1
  #     max_capacity     = 10
  #     min_capacity     = 1

  #     instance_types = ["t3.large"]
  #     capacity_type  = "SPOT"
  #     update_config = {
  #       max_unavailable_percentage = 50 # or set `max_unavailable`
  #     }
  #   }
  # }

  # worker_groups = [
  #   {
  #     name                          = "${var.cluster_name}-${var.regions_short[0]}-worker"
  #     instance_type                 = "t3.large"
  #     # additional_userdata           = "echo foo bar"
  #     asg_desired_capacity          = 2
  #     additional_security_group_ids = [aws_security_group.eks_worker_group_r0.id]
  #   },
  # ]

  providers = {
    aws = aws.r2a
    kubernetes = kubernetes.eks_r2
  }
}

resource "aws_security_group" "eks_worker_group_r2" {

  name = "eks_worker_group_r2"
  vpc_id      = module.vpc_r2s.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      for prefix in var.prefixes: "${prefix}.0.0/16"
    ]
  }

  provider = aws.r2a
}



# output "test" {
#   value = {
#     cluster_primary_security_group_id = module.eks_cluster_r0.cluster_primary_security_group_id,
#     cluster_security_group_id = module.eks_cluster_r0.cluster_security_group_id,
#     worker_security_group_id = module.eks_cluster_r0.worker_security_group_id,
#   }
# }


locals {
  userdata_r2 = <<-EOT
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${module.eks_cluster_r2.cluster_id}
  EOT
}


resource "aws_launch_template" "launch_template_r2" {
  name = "${var.cluster_name}-workers-${var.regions_short[2]}"

  # todo: change to map lookup
  image_id      = lookup(var.worker_image_id, var.regions[2])
  # instance_type = var.worker_instance_type
  instance_type = "t3.large"
  # key_name      = var.worker_key_name
  key_name      = "justinrlee-confluent-dev"

  network_interfaces {
    associate_public_ip_address = true
    security_groups              = [module.eks_cluster_r2.worker_security_group_id, aws_security_group.eks_worker_group_r2.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 50
      # volume_size = var.worker_volume_size
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.worker_role.arn
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    # http_tokens                 = var.require_imdsv2 ? "required" : "optional"
    http_tokens                 = "required"
  }

  user_data = base64encode(local.userdata_r2)

  provider = aws.r2a
}


resource "aws_autoscaling_group" "r2_workers" {

  name             = "${var.cluster_name}-region-workers-r2"
  max_size         = 10
  min_size         = 0
  desired_capacity = 2
  # health_check_grace_period = 300
  # health_check_type         = "ELB"

  vpc_zone_identifier = module.vpc_r2s.public_subnets

  launch_template {
    id      = aws_launch_template.launch_template_r2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${module.eks_cluster_r2.cluster_id}-Region-Node"
    propagate_at_launch = true
  }

  tag {
    value               = "owned"
    key                 = "kubernetes.io/cluster/${module.eks_cluster_r2.cluster_id}"
    propagate_at_launch = true
  }
  ## Todo: auto scaling update policy: max batch 1, pause 5 minutes
  provider = aws.r2a
}