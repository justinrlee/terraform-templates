Instructions

1. Run root Terraform directory to deploy:
    * AWS VPC
    * AWS NLB
    * AWS R53 entries pointing at NLB
    * AWS ACM certificate
    * AWS EKS cluster, with managed node group
    * AWS bastion host
    * ... other resources

2. Modify IMDSv2 for all k8s worker nodes to support AWS Load Balancer Controller:
    * https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-IMDS-existing-instances.html

```sh
aws ec2 modify-instance-metadata-options \
    --instance-id i-1234567898abcdef0 \
    --http-put-response-hop-limit 3 \
    --http-endpoint enabled
```

3. Install AWS Load Balancer Controller: https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/

4. Take output of outer Terraform, use as input variable file for inner Terraform (`k8s` directory)

5. Run inner Terraform to generate manifests to be deployed to Kubernetes cluster

6. Deploy manifests to Kubernetes cluster

TODO: have to figure out how to add security group to managed nodes to allow all traffic from 10.0.0.0/8