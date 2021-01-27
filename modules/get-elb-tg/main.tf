data "external" "example" {
  program = ["bash", "${path.module}/aws.sh"]
  query = {
    autoscaling = var.tagName
  }
}

# on récupère le target group utilisé
data "aws_lb_target_group" "target" {
  count = var.nbTarget
  name = (var.nbTarget == "1") ? "${replace(var.tagName, "." ,"-")}-${var.port}" : "${replace(var.tagName, "." ,"-")}-${var.port}-${count.index + 1}"
}
