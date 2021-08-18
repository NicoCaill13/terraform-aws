
output "ec2RunningId"{
  value = data.aws_instances.ec2-running.ids.0
}
output "ec2RunningIds"{
  value = data.aws_instances.ec2-running.ids
}
output "ec2RunningIp"{
  value = data.aws_instances.ec2-running.private_ips.0
}
output "ec2RunningTagName"{
  value = data.aws_instance.ec2-running.tags.Name
}

output "ec2CreatingId"{
  value = element(aws_instance.new_instance.*.id, 0)
}

output "ec2CreatingIp"{
  value = element(aws_instance.new_instance.*.private_ip, 0)
}

output "ec2CreatingInstanceType"{
  value = element(aws_instance.new_instance.*.instance_type, 0)
}
