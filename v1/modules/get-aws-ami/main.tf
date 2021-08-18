data "aws_ami" "current_ami" {
  most_recent = true
  owners = [
    "self"
  ]

  filter {
    name = "tag:name"
    values = [
      var.env
    ]
  }
  filter {
    name = "state"
    values = [
      "available"
    ]
  }
}

resource "null_resource" "get_new_ami_name" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "./modules/get-aws-ami/imageName.sh ${data.aws_ami.current_ami.description} get-aws-ami new_ami_name"
  }
}

data "local_file" "ami_name" {
  filename = "${path.module}/new_ami_name.txt"
  depends_on = [null_resource.get_new_ami_name]
}