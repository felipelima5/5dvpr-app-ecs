resource "aws_ecs_task_definition" "this" {
  family                   = "${var.application_name}-${var.env}"
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  requires_compatibilities = [var.requires_compatibilities]
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = local.task_definition

  runtime_platform {
    operating_system_family = var.runtime_platform_operating_system_family
    cpu_architecture        = var.runtime_platform_cpu_architecture
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.application_name}-${var.env}"
  retention_in_days = var.cloudwatch_log_retention_in_days

  tags = var.tags
}