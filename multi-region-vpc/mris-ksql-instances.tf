module "ksql_instances" {
    source = "./modules/multi_region_instance_set"

    for_each = var.ksql_clusters

    instance_counts = each.value.counts
    instance_type = each.value.instance_type

    ec2_public_key_names = var.ec2_public_key_names

    public_subnets = [
        module.vpc_r0s.public_subnets,
        module.vpc_r1s.public_subnets,
        module.vpc_r2s.public_subnets,
    ]

    private_subnets = [
        module.vpc_r0s.private_subnets,
        module.vpc_r1s.private_subnets,
        module.vpc_r2s.private_subnets,
    ]
    
    public_security_groups = [
        [aws_security_group.r0s_allow_egress.id, aws_security_group.r0s_allow_broker.id,],
        [aws_security_group.r1s_allow_egress.id, aws_security_group.r1s_allow_broker.id,],
        [aws_security_group.r2s_allow_egress.id, aws_security_group.r2s_allow_broker.id,],
    ]

    private_security_groups = [
        [aws_security_group.r0s_allow_egress.id, aws_security_group.r0s_allow_broker.id,],
        [aws_security_group.r1s_allow_egress.id, aws_security_group.r1s_allow_broker.id,],
        [aws_security_group.r2s_allow_egress.id, aws_security_group.r2s_allow_broker.id,],
    ]

    cluster_name = var.cluster_name
    type = "ksql"
    label = "${each.value.name}"

    providers = {
        aws.r0a = aws.r0a
        aws.r1a = aws.r1a
        aws.r2a = aws.r2a
    }

}