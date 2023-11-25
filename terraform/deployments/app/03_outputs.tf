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
