variable "environment" {
  type        = string
  description = "The environment of application"
}

variable "tags" {
  type        = map(string)
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

variable "assume_role_policy_document" {
  type        = string
  description = "The JSON format of assume role policy"
}

variable "aws_managed_policy_arns" {
  type        = set(string)
  description = "A list of AWS managed policy ARN"
}

variable "customized_policies" {
  type        = map(string)
  description = "A list of JSON format of IAM policy"
}

variable "has_iam_instance_profile" {
  type        = bool
  description = "If to create instance profile for the role"
}
