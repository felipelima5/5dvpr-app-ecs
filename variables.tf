# ------- TASK DEFINITION -------------------
variable "task_definition" {
  type = object({
    requires_compatibilities                 = string
    network_mode                             = string
    cpu                                      = number
    memory                                   = number
    runtime_platform_operating_system_family = string
    runtime_platform_cpu_architecture        = string # X86_64 / ARM64

  })
  default = {
    requires_compatibilities                 = ""
    network_mode                             = ""
    cpu                                      = null
    memory                                   = null
    runtime_platform_operating_system_family = ""
    runtime_platform_cpu_architecture        = "" # X86_64 / ARM64
  }
}

variable "container_definitions" {
  type = object({
    image   = string
    cpu     = number
    memory  = number
    command = string

  })
  default = {
    image   = ""
    cpu     = null
    memory  = null
    command = ""
  }
}


variable "application_name" {
  type = string
}

variable "region" {
  type = string
}

variable "application_port" {
  type = number
}


# --------- SERVICE -----------
variable "service_scalling" {
  type = object({
    desired_count                 = number
    max_capacity                  = number
    percentual_to_scalling_target = number
    time_to_scalling_in           = number
    time_to_scalling_out          = number

  })
  default = {
    desired_count                 = null
    max_capacity                  = null
    percentual_to_scalling_target = null
    time_to_scalling_in           = null
    time_to_scalling_out          = null
  }
}

variable "service" {
  type = object({
    capacity_provider_fargate        = string
    capacity_provider_fargate_weight = number

    capacity_provider_fargate_spot        = string
    capacity_provider_fargate_spot_weight = number

    deployment_minimum_healthy_percent = number
    deployment_maximum_percent         = number
    assign_public_ip                   = bool
    vpc_id                             = string
    subnets_ids                        = list(string)

  })
  default = {
    capacity_provider_fargate        = ""
    capacity_provider_fargate_weight = null

    capacity_provider_fargate_spot        = ""
    capacity_provider_fargate_spot_weight = null

    deployment_minimum_healthy_percent = null
    deployment_maximum_percent         = null
    assign_public_ip                   = null
    vpc_id                             = ""
    subnets_ids                        = []
  }
}

variable "ecs_cluster_name" {
  type = string
}

variable "tags" {
  type = map(string)
}


# ------- LOAD BALANCER  -------------------
variable "loadbalancer_application" {
  type = object({
    arn_listener           = string
    listener_host_rule     = list(string)
    priority_rule_listener = number
    security_group         = list(string)
    listener_paths         = list(string)

  })
  default = {
    arn_listener           = ""
    listener_host_rule     = []
    priority_rule_listener = null
    security_group         = []
    listener_paths         = []
  }
}

variable "target_group" {
  type = object({
    name                      = string
    protocol                  = string
    protocol_version          = string
    deregistration_delay      = number
    health_check_path         = string
    health_check_success_code = string

  })
  default = {
    name                      = ""
    protocol                  = ""
    protocol_version          = ""
    deregistration_delay      = null
    health_check_path         = ""
    health_check_success_code = ""
  }
}


# ------- OBSERVABILITY  -------------------

variable "observability" {
  type = object({
    cloudwatch_log_retention_in_days = number

  })
  default = {
     cloudwatch_log_retention_in_days = null
  }
}