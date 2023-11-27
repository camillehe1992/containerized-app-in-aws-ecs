# General Variables
variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_profile" {
  type        = string
  default     = "default"
  description = "AWS profile which used for terraform infra deployment"
}

variable "environment" {
  type        = string
  description = "The environment of application"
}

variable "nickname" {
  type        = string
  description = "The nickname of application. Must be lowercase without special chars"
}

variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

# Deployment Specific Variables
variable "internal" {
  type        = bool
  default     = false
  description = "If the ALB is internal"
}
variable "security_groups" {
  type        = list(string)
  description = "The secuirty group ids for ALB"
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "The subnet ids for ALB"
}
