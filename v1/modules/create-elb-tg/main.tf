resource "aws_lb_target_group_attachment" "target" {
  for_each = toset( var.arn)
  target_group_arn = each.key
  target_id        = var.target
}

resource "null_resource" "waiting-register"{
  for_each = toset( var.arn)
  provisioner "local-exec" {
    command = "aws elbv2 wait target-in-service --target-group-arn ${each.key} --targets Id=${var.target}"
  }
  depends_on = [aws_lb_target_group_attachment.target]
}

resource "null_resource" "deregister"{
  for_each = toset( var.arn)
  provisioner "local-exec" {
    command = "aws elbv2 deregister-targets --target-group-arn ${each.key} --targets Id=${var.oldTarget} && aws elbv2 wait target-deregistered --target-group-arn ${each.key} --targets Id=${var.oldTarget}"
  }
  depends_on = [null_resource.waiting-register]
}