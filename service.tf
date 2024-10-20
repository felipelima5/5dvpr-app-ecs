resource "aws_ecs_service" "this" {
  name            = var.application_name
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.service_scalling.desired_count

  deployment_minimum_healthy_percent = var.service.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.service.deployment_maximum_percent

  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = var.service.subnets_ids
    assign_public_ip = var.service.assign_public_ip
  }

  tags = var.tags

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.application_name #Nome do Container dentro da taskdefinition
    container_port   = var.application_port #porta do container em container definitions na task
  }


  capacity_provider_strategy {
    capacity_provider = var.service.capacity_provider_fargate
    weight            = var.service.capacity_provider_fargate_weight
  }

  capacity_provider_strategy {
    capacity_provider = var.service.capacity_provider_fargate_spot
    weight            = var.service.capacity_provider_fargate_spot_weight
  }
}

resource "aws_security_group" "this" {
  name        = "acl-${var.application_name}"
  description = "Allow Traffic Communication ${var.application_name}"
  vpc_id      = var.service.vpc_id

  ingress {
    description     = "Allow Traffic From ALB"
    from_port       = var.application_port
    to_port         = var.application_port
    protocol        = "tcp"
    security_groups = var.loadbalancer_application.security_group
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_appautoscaling_target" "ecs_target_memory" {
  max_capacity       = var.service_scalling.max_capacity
  min_capacity       = var.service_scalling.desired_count
  resource_id        = "service/${var.ecs_cluster_name}/${var.application_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_appautoscaling_target.ecs_target_cpu]
}

resource "aws_appautoscaling_policy" "replicas_memory" {
  name               = "ECSServiceAverageMemoryUtilization"
  service_namespace  = aws_appautoscaling_target.ecs_target_memory.service_namespace
  scalable_dimension = aws_appautoscaling_target.ecs_target_memory.scalable_dimension
  resource_id        = aws_appautoscaling_target.ecs_target_memory.resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.service_scalling.percentual_to_scalling_target
    scale_in_cooldown  = var.service_scalling.time_to_scalling_in
    scale_out_cooldown = var.service_scalling.time_to_scalling_out
  }


}


resource "aws_appautoscaling_target" "ecs_target_cpu" {
  max_capacity       = var.service_scalling.max_capacity
  min_capacity       = var.service_scalling.desired_count
  resource_id        = "service/${var.ecs_cluster_name}/${var.application_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "replicas_cpu" {
  name               = "ECSServiceAverageCPUUtilization"
  service_namespace  = aws_appautoscaling_target.ecs_target_cpu.service_namespace
  scalable_dimension = aws_appautoscaling_target.ecs_target_cpu.scalable_dimension
  resource_id        = aws_appautoscaling_target.ecs_target_cpu.resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.service_scalling.percentual_to_scalling_target
    scale_in_cooldown  = var.service_scalling.time_to_scalling_in
    scale_out_cooldown = var.service_scalling.time_to_scalling_out
  }
}