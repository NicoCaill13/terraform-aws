output "ami_name"{
  value = data.local_file.ami_name.content
}

output "ami_file"{
  value = data.aws_ami.current_ami.description
}

output "ami_id"{
  value = data.aws_ami.current_ami.id
}