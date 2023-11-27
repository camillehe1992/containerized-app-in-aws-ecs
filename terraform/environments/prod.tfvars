# General Variables
tags = {
  environment      = "prod"
  nickname         = "pokemon"
  application_name = "pokemon-playground"
  application_desc = "A RestAPI server for Pokemon playground that deployed in AWS ECS as a containerized application"
  emails           = "group@example.com"
  repo             = "https://github.com/camillehe1992/containerized-app-in-aws-ecs"
}

# Deployment Specific Variables
# Shared
security_groups = ["sg-0579f97438569f812"]
alb_subnet_ids  = ["subnet-05caf66e740964d47", "subnet-0ac7236fe344b9a9c"]

# App
image            = "camillehe1992/sample-vue-app:latest"
ecs_cluster_name = "PROD-APP-ECS-CLUSTER"
vpc_id           = "vpc-02fd20cf215e9a54b"

