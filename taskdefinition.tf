resource "aws_ecs_task_definition" "this" {
  family                   = var.application_name
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  requires_compatibilities = [var.task_definition.requires_compatibilities]
  network_mode             = var.task_definition.network_mode
  cpu                      = var.task_definition.cpu
  memory                   = var.task_definition.memory
  container_definitions    = local.task_definition

  runtime_platform {
    operating_system_family = var.task_definition.runtime_platform_operating_system_family
    cpu_architecture        = var.task_definition.runtime_platform_cpu_architecture
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.application_name}"
  retention_in_days = var.observability.cloudwatch_log_retention_in_days

  tags = var.tags
}