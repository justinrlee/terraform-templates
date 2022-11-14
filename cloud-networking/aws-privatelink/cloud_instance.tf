resource "aws_key_pair" "test" {
  key_name   = "${var.environment_name}"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_security_group" "bastion_ssh" {
  description = "SSH"
  name        = "${var.environment_name}-allow-ssh"
  vpc_id      = module.vpc.vpc_id

  ingress = [{
    description      = null,
    protocol         = "tcp",
    cidr_blocks      = ["0.0.0.0/0"],
    from_port        = 22,
    to_port          = 22,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]

  depends_on = [
    module.vpc
  ]
}

resource "aws_security_group" "bastion_allow_egress" {
  description = "SSH"
  name        = "${var.environment_name}-allow-egress"
  vpc_id      = module.vpc.vpc_id

  egress = [{
    description      = null,
    protocol         = "-1",
    cidr_blocks      = ["0.0.0.0/0"],
    from_port        = 0,
    to_port          = 0,
    ipv6_cidr_blocks = null,
    prefix_list_ids  = null,
    security_groups  = null,
    self             = null
  }]
  
  depends_on = [
    module.vpc
  ]
}

resource "aws_instance" "bastion" {
  count                       = 1
  ami                         = lookup(var.aws_amis, var.region)
  instance_type               = "t3.xlarge"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.test.key_name

  subnet_id                   = module.vpc.public_subnets[0]
  # subnet_id                   = aws_subnet.subnets[var.zones[0]].id
  
  vpc_security_group_ids      = [
    aws_security_group.bastion_ssh.id,
    aws_security_group.bastion_allow_egress.id,
  ]
  
  root_block_device {
    delete_on_termination = true
    volume_size = 40
  }

  tags = {
    Name = "${var.environment_name}-bastion"
    Provenance = "Cloud Networking for ${var.environment_name}"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [
    module.vpc
  ]
}

