resource "aws_lb_target_group" "target_group" {
  name        = var.name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb" "load_balancer" {
  name               = var.load_balancer_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group
  subnets            = var.subnet

  tags = {
    env = var.env
  }
}

resource "aws_lb_target_group_attachment" "target" {
  target_group_arn = var.arn
  target_id        = var.instance_id
}


