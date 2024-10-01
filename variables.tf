# ------- TaskDefinition -------------------
variable "application_name" {
  type = string
}

variable "requires_compatibilities" {
  type = string
}

variable "network_mode" {
  type = string
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "container_definitions_image" {
  type = string
}

variable "container_definitions_cpu" {
  type = number
}

variable "container_definitions_memory" {
  type = number
}

variable "container_definitions_memory_reservation" {
  type = number
}

variable "region" {
  type = string
}

variable "container_definitions_command" {
  type = string
}

variable "runtime_platform_operating_system_family" {
  type = string
}

variable "runtime_platform_cpu_architecture" {
  type = string
}

variable "cloudwatch_log_retention_in_days" {
  type = number
}

variable "application_port" {
  type = number
}


# ------- Service -------------------

variable "ecs_cluster_name" {
  type = string
}

variable "service_desired_count" {
  type = number
}

variable "service_deployment_minimum_healthy_percent" {
  type = number
}

variable "service_deployment_maximum_percent" {
  type = number
}

variable "service_assign_public_ip" {
  type = bool
}

variable "vpc_id" {
  type = string
}

variable "subnets_ids" {
  type = list(string)
}


variable "security_group_alb" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

# ------- LoadBalancer  ------------------- 

variable "target_protocol" {
  type = string
}

variable "target_protocol_version" {
  type = string
}

variable "target_deregistration_delay" {
  type = number
}

variable "target_health_check_path" {
  type = string
}

variable "target_health_check_success_code" {
  type = string
}

variable "alb_listener_host_rule" {
  type = string
}


variable "env" {
  type = string
}

variable "scalling_max_capacity" {
  type = number
}


variable "percentual_to_scalling_target" {
  type = number
}

variable "time_to_scalling_in" {
  type = number
}

variable "time_to_scalling_out" {
  type = number
}


variable "capacity_provider_fargate" {
  type = string
}

variable "capacity_provider_fargate_weight" {
  type = number
}

variable "capacity_provider_fargate_spot" {
  type = string
}

variable "capacity_provider_fargate_spot_weight" {
  type = number
}

variable "arn_listener_alb" {
  type = string
}

variable "priority_rule_listener" {
  type = number
}