resource "aws_launch_configuration" "as_conf" {
  name   = var.name
  image_id      = var.amiId
  instance_type = var.instanceType
  security_groups = var.securityGroups
  lifecycle {
    create_before_destroy = true
  }
}


resource "null_resource" "updateAutoScaling"{
  provisioner "local-exec" {
    command = "aws autoscaling update-auto-scaling-group --auto-scaling-group-name ${var.autoscalingName} --launch-configuration-name ${var.name} --vpc-zone-identifier ${var.autoscalingVpc}"
  }
  depends_on = [aws_launch_configuration.as_conf]
}

resource "null_resource" "updateAutoScalingEc2"{
  for_each = toset( var.ec2RunningIds )
  provisioner "local-exec" {
    command = "aws autoscaling terminate-instance-in-auto-scaling-group --instance-id ${each.key} --no-should-decrement-desired-capacity"
  }
  depends_on = [null_resource.updateAutoScaling]
}