locals {
  task_definition = <<TASK_DEFINITION
[
  {
    "name": "${var.application_name}",
    "image": "${var.container_definitions.image}",
    "cpu": ${var.container_definitions.cpu},
    "memory": ${var.container_definitions.memory},
    "essential": true,
    "environmentFiles": [],
    "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/${var.application_name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
    "portMappings": [
      {
        "containerPort": ${var.application_port}
      }
    ],
    "command": ["${var.container_definitions.command}"]
  }
]
TASK_DEFINITION
}