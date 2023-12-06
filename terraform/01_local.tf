locals {
  ecs_cluster_arn   = "arn:${data.aws_partition.current.partition}:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${var.ecs_cluster_name}"
  load_balancer_arn = "arn:${data.aws_partition.current.partition}:elasticloadbalancing:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:loadbalancer/${var.environment}-${var.nickname}"
}

