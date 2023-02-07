resource "aws_key_pair" "r1" {
  key_name   = var.environment_name
  public_key = file("~/.ssh/id_rsa.pub")
  provider = aws.r1
}

resource "aws_security_group" "r1_ssh" {
  description = "SSH"
  name        = "${var.environment_name}-allow-ssh"
  vpc_id      = aws_vpc.r1.id

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

  provider = aws.r1
}

resource "aws_security_group" "r1_egress" {
  description = "SSH"
  name        = "${var.environment_name}-allow-egress"
  vpc_id      = aws_vpc.r1.id

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

  provider = aws.r1
}

resource "aws_instance" "r1" {
  ami                         = lookup(var.aws_amis, var.r1.region)
  instance_type               = "t3.xlarge"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.r1.key_name

  subnet_id = aws_subnet.r1[var.r1.zone].id
  # subnet_id                   = aws_subnet.subnets[var.zones[0]].id

  vpc_security_group_ids = [
    aws_security_group.r1_ssh.id,
    aws_security_group.r1_egress.id,
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = 40
  }

  lifecycle {
    ignore_changes = [tags]
  }

  provider = aws.r1
}

output "r1_bastion" {
  value = {
    public_dns = aws_instance.r1.public_dns,
    public_ip = aws_instance.r1.public_ip,
  }
}