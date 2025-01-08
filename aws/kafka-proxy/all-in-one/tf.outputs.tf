output "bastion" {
  value = "${aws_instance.bastion.public_dns} : ${aws_instance.bastion.private_dns}"
}