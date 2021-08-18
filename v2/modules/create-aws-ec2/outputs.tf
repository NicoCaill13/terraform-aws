output "amiId"{
  value = aws_instance.new_instance.ami
}

output "tags_name"{
  value = aws_instance.new_instance.tags.Name
}

output "instanceId"{
  value = aws_instance.new_instance.id
}

output "privateIp"{
  value = aws_instance.new_instance.private_ip
}

output "publicIp"{
  value = aws_instance.new_instance.public_ip
}

