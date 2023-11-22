module "ecs_task_execution_role" {
  source = "./modules/iam"

  environment = var.environment
  tags        = var.tags

  role_name                   = "${var.env}-${var.nickname}-ecsTaskExecutionRole"
  role_description            = "The task execution role grants the Amazon ECS container and Fargate agents permission to make AWS API calls on your behalf."
  assume_role_policy_document = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json
  aws_managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  ]
  customized_policies = {
    allow-cwlogs-ecr-policy = data.aws_iam_policy_document.ecs_tasks_execution_role_inline_policy.json
  }
  has_iam_instance_profile = false
}

module "ecs_task_role" {
  source = "../01-modules/iam"

  environment = var.environment
  tags        = var.tags

  role_name                   = "${var.env}-${var.nickname}-ecsTaskRole"
  role_description            = "The role is used for container that running in ECS container instances to access other AWS services"
  assume_role_policy_document = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json
  aws_managed_policy_arns     = []
  customized_policies = {
    allow-secret-manager-readonly-policy = data.aws_iam_policy_document.ecs_tasks_role_inline_policy.json
  }
  has_iam_instance_profile = false
}
