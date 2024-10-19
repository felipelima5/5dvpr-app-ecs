#Role ExecutionRole
resource "aws_iam_role" "task_role" {
  name               = "${var.application_name}-task-${random_password.ecs_task_role_name_sufixo.result}"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_assume_policy.json
}

# Trust Relationship
data "aws_iam_policy_document" "ecs_task_role_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

#Anexando Policy
resource "aws_iam_role_policy" "ecs_task_role_get_policy" {
  name   = "${var.application_name}-task-${random_password.ecs_task_role_name_sufixo.result}"
  role   = aws_iam_role.execution_role.id
  policy = data.aws_iam_policy_document.ecs_task_role_policy.json
}


#Policy
data "aws_iam_policy_document" "ecs_task_role_policy" {

  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    effect = "Allow"
    resources = [
      "*"
    ]

    sid = "TaskRolePermissions"
  }
}

resource "random_password" "ecs_task_role_name_sufixo" {
  length      = 5
  special     = false
  upper       = false
  lower       = false
  number      = true
  numeric     = true
  min_numeric = 5
}