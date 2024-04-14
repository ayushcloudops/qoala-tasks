output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_id" {
  value = aws_subnet.private_subnet_1.id
}

output "pub_subnet_id" {
  value = aws_subnet.pub_subnet_1.id
}

output "pub_subnet_id_2" {
  value = aws_subnet.pub_subnet_2.id
}

output "sg_id" {
  value = aws_security_group.qoala_elb.id
}