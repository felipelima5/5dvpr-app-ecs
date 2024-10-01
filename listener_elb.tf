resource "aws_lb_target_group" "this" {
  name                 = "${var.application_name}-svc-app"
  port                 = var.application_port
  protocol             = var.target_protocol
  protocol_version     = var.target_protocol_version
  target_type          = "ip"
  deregistration_delay = var.target_deregistration_delay
  health_check {
    enabled             = true
    path                = var.target_health_check_path
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = var.target_health_check_success_code #Success Code
  }
  vpc_id = var.vpc_id

  tags = var.tags
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.arn_listener_alb
  priority     = var.priority_rule_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = ["${var.alb_listener_host_rule}"]
    }
  }
}