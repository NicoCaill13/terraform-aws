data "aws_autoscaling_group" "asg" {
  name = var.name
}

data "aws_launch_configuration" "asg" {
  name = data.aws_autoscaling_group.asg.launch_configuration
}

resource "null_resource" "get_launch_configuration_name" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "./modules/get-aws-ami/imageName.sh ${data.aws_autoscaling_group.asg.launch_configuration} get-aws-asg lauch_configuration"
  }
}

data "local_file" "launch_configuration_name" {
  filename = "${path.module}/lauch_configuration.txt"
  depends_on = [null_resource.get_launch_configuration_name]
}
