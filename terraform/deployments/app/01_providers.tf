terraform {
  backend "s3" {}

  required_version = ">= 1.4.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.25.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile != "default" ? var.aws_profile : null
}
