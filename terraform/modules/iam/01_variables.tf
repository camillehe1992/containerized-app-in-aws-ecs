variable "environment" {
  type        = string
  description = "The environment of application"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "role_name" {
  type        = string
  description = "The name of IAM role"
}

variable "role_description" {
  type        = string
  description = "The description of IAM role"
}

variable "assume_role_policy_identifiers" {
  type        = list(string)
  default     = ["ecs-tasks.amazonaws.com"]
  description = "The AWS service identitifers that are allowed to assume the role"
}

variable "aws_managed_policy_arns" {
  type        = set(string)
  default     = []
  description = "A list of AWS managed policy ARN"
}

variable "customized_policies" {
  type        = map(string)
  default     = {}
  description = "A list of JSON format of IAM policy"
}

variable "has_iam_instance_profile" {
  type        = bool
  default     = false
  description = "If to create instance profile for the role"
}
