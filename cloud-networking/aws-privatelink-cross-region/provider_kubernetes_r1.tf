# These providers depend on the EKS cluster
data "aws_eks_cluster" "r1" {
  name = module.r1_eks.cluster_name

  provider = aws.r1
}

data "aws_eks_cluster_auth" "r1" {
  name = module.r1_eks.cluster_name

  provider = aws.r1
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.r1.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.r1.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.r1.token

  alias = "r1"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.r1.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.r1.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.r1.token
  }

  alias = "r1"
}