module "ecs_task_execution_role" {
  source = "../../modules/iam"

  environment = var.environment
  tags        = var.tags

  role_name        = "${var.environment}-${var.nickname}-ecsTaskExecutionRole"
  role_description = "The task execution role grants the Amazon ECS container and Fargate agents permission to make AWS API calls on your behalf."
  customized_policies = {
    allow-cwlogs-ecr-policy = data.aws_iam_policy_document.ecs_tasks_execution_role_inline_policy.json
  }
}

module "ecs_task_role" {
  source = "../../modules/iam"

  environment = var.environment
  tags        = var.tags

  role_name        = "${var.environment}-${var.nickname}-ecsTaskRole"
  role_description = "The role is used for container that running in ECS container instances to access other AWS services"
  customized_policies = {
    allow-secret-manager-readonly-policy = data.aws_iam_policy_document.ecs_tasks_role_inline_policy.json
  }
}
