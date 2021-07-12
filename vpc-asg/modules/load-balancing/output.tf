output "targetGroup" {
  value = aws_lb_target_group.targetGroup
}

output "id_targetGroup" {
  value = aws_lb_target_group.targetGroup.id
}

output "arn_targetGroup" {
  value = aws_lb_target_group.targetGroup.arn
}

output "loadBalancer" {
  value = aws_lb.load_balancer
}

output "dns_loadBalancer" {
  value = aws_lb.load_balancer.dns_name
}