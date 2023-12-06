output "ecs_task_execution_role_arn" {
  value = module.ecs_task_execution_role.role.arn
}

output "ecs_task_role_arn" {
  value = module.ecs_task_role.role.arn
}

output "alb" {
  value = {
    arn      = aws_lb.this.arn
    dns_name = aws_lb.this.dns_name
  }
}

output "aws_ecs_task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

output "aws_ecs_service" {
  value = {
    cluster = aws_ecs_service.this.cluster
    arn     = aws_ecs_service.this.id
  }
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.this.arn
}
