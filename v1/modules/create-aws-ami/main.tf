resource "aws_ami_from_instance" "ami" {
  name = var.name
  description = var.name
  source_instance_id = var.source_instance_id
  tags = {
    name = var.env
    Name = var.name
  }

  connection {
    type = "ssh"
    user = "admin"
    agent = false
    host = var.host
    private_key = file("~/.ssh/KeepCoolKey.pem")
  }
  provisioner "local-exec"{
    command = <<EOT
    ./modules/create-aws-ec2/check22.sh ${var.host}
    EOT
  }
}