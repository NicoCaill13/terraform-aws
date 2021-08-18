output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}


output "dns_name" {
  value = aws_lb.load_balancer.dns_name
}

output "zone_id" {
  value = aws_lb.load_balancer.zone_id
}

output "arn" {
  value = aws_lb.load_balancer.arn
}

output "id" {
  value = aws_lb.load_balancer.id
}
