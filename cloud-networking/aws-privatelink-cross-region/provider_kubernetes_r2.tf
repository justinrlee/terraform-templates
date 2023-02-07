# These providers depend on the EKS cluster
data "aws_eks_cluster" "r2" {
  name = module.r2_eks.cluster_name

  provider = aws.r2
}

data "aws_eks_cluster_auth" "r2" {
  name = module.r2_eks.cluster_name

  provider = aws.r2
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.r2.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.r2.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.r2.token

  alias = "r2"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.r2.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.r2.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.r2.token
  }
  
  alias = "r2"
}