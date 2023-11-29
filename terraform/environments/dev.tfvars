# General Variables
tags = {
  environment      = "dev"
  nickname         = "strapi"
  application_name = "strapi-playground"
  application_desc = "A containerized RestAPI server for Strapi project"
  emails           = "group@example.com"
  repo             = "https://github.com/camillehe1992/containerized-app-in-aws-ecs"
}

# Deployment Specific Variables
# Shared
security_groups = ["sg-00fe42c9972b4e4af"]
alb_subnet_ids  = ["subnet-04839c488f31e2829", "subnet-08122d3fc6e3ce9b1"]

# App
ecs_cluster_name = "DEV-APP-ECS-CLUSTER"
vpc_id           = "vpc-06c47d9bb120348df"
container_port   = 1337

