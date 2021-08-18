# on récupère l'instance en cours
data "aws_instances" "ec2-running" {
  filter {
    name = "tag:slug"
    values = [
      var.env
    ]
  }
}

data "aws_instance" "ec2-running" {
  instance_id = data.aws_instances.ec2-running.ids.0
}


resource "aws_instance" "new_instance" {
  ami = var.ami_id
  instance_type = data.aws_instance.ec2-running.instance_type
  subnet_id = (var.subnet == "public") ? var.subnet_kc_public : var.subnet_kc_private
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name = var.key_name
  tags = {
    Name = data.aws_instance.ec2-running.tags.Name
    slug = data.aws_instance.ec2-running.tags.slug
    env = data.aws_instance.ec2-running.tags.env
  }

  connection {
    type = "ssh"
    user = "admin"
    agent = false
    host = self.private_ip
    private_key = file("~/.ssh/key")
  }

  provisioner "local-exec"{
    command = <<EOT
    ./modules/create-aws-ec2/check22.sh ${element(aws_instance.new_instance.*.private_ip, 0)}
    ./scripts/${var.isDocker}.sh ${var.name} ${self.private_ip} ${var.directory}
    if [ ${var.isDocker} = "dockerOn" ]; then
    ssh gitlab@${self.private_ip} cd /var/www/html/${var.directory} && docker-compose down && docker-compose build \
    && sudo service docker restart docker-compose up -d && exit
    fi
    EOT
  }
}



