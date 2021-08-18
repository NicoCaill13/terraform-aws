resource "aws_iam_server_certificate" "elb_cert" {
  name              = "${var.env}-${var.alias}.${var.dns_domain_name}"
  certificate_body  = var.certificate_body
  certificate_chain = var.certificate_chain
  private_key       = var.private_key

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = var.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = var.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_iam_server_certificate.elb_cert.arn
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}


