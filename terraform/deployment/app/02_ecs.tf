# https://registry.terraform.io/providers/hashicorp/aws/5.0.0/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "this" {
  family = "${var.environment}-${var.nickname}"
  # task_role_arn = data.terraform_remote_state.shared.outputs.ecs_
  container_definitions = jsonencode([
    {
      name               = "${var.environment}-${var.nickname}"
      image              = var.image
      cpu                = var.cpu
      memory             = var.memory
      execution_role_arn = data.terraform_remote_state.shared.outputs.ecs_task_execution_role_arn
      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
      logConfiguration = {
        logDriver = "fluentd",
        options = {
          fluentd-address = "unix:///var/run/fluent.sock",
          tag             = "logs-from-${var.nickname}"
        }
      }
      essential = true
    }
  ])

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/5.0.0/docs/resources/lb_target_group
resource "aws_lb_target_group" "this" {
  name        = "${var.environment}-${var.nickname}"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path = var.health_check
  }

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/5.0.0/docs/resources/lb_listener
resource "aws_lb_listener" "this" {
  load_balancer_arn = data.terraform_remote_state.shared.outputs.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/5.0.0/docs/resources/ecs_service
resource "aws_ecs_service" "this" {
  name                              = "${var.environment}-${var.nickname}"
  cluster                           = local.ecs_cluster_arn
  task_definition                   = aws_ecs_task_definition.this.arn
  desired_count                     = var.desired_count
  enable_ecs_managed_tags           = true
  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "${var.environment}-${var.nickname}"
    container_port   = var.container_port
  }

  force_new_deployment = true
  # triggers = {
  #   redeployment = timestamp()
  # }

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/5.0.0/docs/resources/appautoscaling_target
resource "aws_appautoscaling_target" "this" {
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/5.0.0/docs/resources/appautoscaling_policy
resource "aws_appautoscaling_policy" "this" {
  name               = "TargetTrackingScalingCPUUtilization"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.cpu_utilization_target_value
    scale_in_cooldown  = 60
    scale_out_cooldown = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
