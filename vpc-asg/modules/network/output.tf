output "id_vpc" {
  value = aws_vpc.vpc.id
}

output "id_subnet_private" {
  value = aws_subnet.subnet_private.id
}

output "id_subnets_public" {
  value = aws_subnet.subnets_public.*.id
}

output "id_sg_load_balancer" {
  value = aws_security_group.sg_load_balancer.id
}

output "id_sg_public" {
  value = aws_security_group.sg_public.id
}

output "id_sg_private" {
  value = aws_security_group.sg_private.id
}