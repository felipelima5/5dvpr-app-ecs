resource "aws_lb_target_group" "this" {
  name                 = var.target_group.name
  port                 = var.application_port
  protocol             = var.target_group.protocol
  protocol_version     = var.target_group.protocol_version
  target_type          = "ip"
  deregistration_delay = var.target_group.deregistration_delay
  health_check {
    enabled             = true
    path                = var.target_group.health_check_path
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = var.target_group.health_check_success_code #Success Code
  }
  vpc_id = var.service.vpc_id

  tags = var.tags
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.loadbalancer_application.arn_listener
  priority     = var.loadbalancer_application.priority_rule_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = var.loadbalancer_application.listener_paths
    }
  }

  condition {
    host_header {
      values = var.loadbalancer_application.listener_host_rule
    }
  }
}