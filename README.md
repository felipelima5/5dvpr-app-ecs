
<div align="center">
  
   ![Metabase Product Screenshot](docs/images/amazon-ecs.png)
   
</div>

# How to use terraform module to create an ecs fargate app service REST 


### Step 1: Create a File `config.tf`

 ```hcl
 provider "aws" {
  region  = var.region
  profile = "default"
} 

terraform {
  backend "s3" {
    bucket  = "state-tf"
    key     = "states/infra.tfstate"
    encrypt = "true"
    region  = "us-east-2"
    profile = "homolog"
  }
}  

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "*${var.subnet_type}*"
  }
}

locals {
  subnets = data.aws_subnets.this.ids[*]
}
```




### create a file `variables.tf` 

```hcl
variable "vpc_id" {
  type    = string
  default = "vpc-xxxxxxxxxxxxx"
}

variable "subnet_type" {
  type    = string
  default = "private"
}

variable "region" {
  type    = string
  default = "us-east-1"
}
```


### create a file `versions.tf` 

```hcl
terraform {
  required_version = "~> 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68.0"
    }
  }
}
```



### create a file `app.tf` 

```hcl
module "api-service" {
  source = "git::git@github.com:selectsolucoes/terraform-module-ecs-app.git?ref=v2.0.0"

  region           = var.region
  application_name = "api-service"
  application_port = 80 # Utilizada na task definition e target group
  ecs_cluster_name = "dev"

  observability = {
    cloudwatch_log_retention_in_days = 3
  }

  # PARÂMETROS TASK DEFINITION
  task_definition = {
    requires_compatibilities                 = "FARGATE"
    network_mode                             = "awsvpc"
    cpu                                      = 256
    memory                                   = 512
    runtime_platform_operating_system_family = "LINUX"
    runtime_platform_cpu_architecture        = "X86_64" # X86_64 / ARM64
  }
  container_definitions = {
    image   = "nginx:latest"
    cpu     = 256
    memory  = 512
    command = "" # "nodejs,start"
  }


  # PARÂMETROS DO SERVIÇO
  service = {
    capacity_provider_fargate        = "FARGATE"
    capacity_provider_fargate_weight = 2 # 50% de peso FARGATE OnDemand

    capacity_provider_fargate_spot        = "FARGATE_SPOT"
    capacity_provider_fargate_spot_weight = 1 # 50% de peso FARGATE Spot

    deployment_minimum_healthy_percent = 100
    deployment_maximum_percent         = 200
    assign_public_ip                   = false
    vpc_id                             = var.vpc_id
    subnets_ids                        = local.subnets
  }

  service_scalling = {
    desired_count                 = 0
    max_capacity                  = 0
    percentual_to_scalling_target = 70
    time_to_scalling_in           = 300
    time_to_scalling_out          = 300
  }


  # PARÂMETROS DO LOADBALANCER
  loadbalancer_application = {
    arn_listener           = "arn:aws:elasticloadbalancing:us-east-1:xxxxxxxxxx:listener/app/alb/986dadcd9a20a9f0/78936970227ccd2d"
    listener_host_rule     = ["app.dominio.com.br", "api-vendas.dominio.com.br"]
    listener_paths         = ["/*"]
    priority_rule_listener = 1
    security_group         = ["sg-xxxxxxxxxxxxx"] #Security Group do LoadBalancer Application que enviará as requests
  }


  #PARÂMETROS DO TARGET GROUP
  target_group = {
    name                      = "api-service"
    protocol                  = "HTTP"
    protocol_version          = "HTTP1"
    deregistration_delay      = 62
    health_check_path         = "/healthcheck/ready"
    health_check_success_code = "200-255"
  }

  tags = {
    ManagedBy = "IaC"
  }
}

```
