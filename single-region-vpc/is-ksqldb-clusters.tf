module "ksqldb_clusters" {
    source = "./modules/instance_set"

    for_each = var.ksqldb_clusters

    instance_counts = each.value.counts
    instance_type = each.value.instance_type

    ec2_public_key_names = var.ec2_public_key_names
    
    iam_instance_profile = var.iam_instance_profile

    public_subnets = [
        module.vpc_r0s.public_subnets,
    ]

    private_subnets = [
        module.vpc_r0s.private_subnets,
    ]
    
    public_security_groups = [
        [aws_security_group.r0s_allow_egress.id, aws_security_group.r0s_allow_internal.id,],
    ]

    private_security_groups = [
        [aws_security_group.r0s_allow_egress.id, aws_security_group.r0s_allow_internal.id,],
    ]

    cluster_name = var.cluster_name
    type = "ksql"
    label = "${each.value.name}"

    providers = {
        aws.r0a = aws.r0a
    }

}