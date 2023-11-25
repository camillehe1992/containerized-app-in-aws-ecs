output "alb" {
  value = {
    arn      = aws_lb.this.arn
    dns_name = aws_lb.this.dns_name
  }
}

output "ecs_task_execution_role_arn" {
  value = module.ecs_task_execution_role.role.arn
}

output "ecs_task_role_arn" {
  value = module.ecs_task_role.role.arn
}
