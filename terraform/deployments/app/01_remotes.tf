data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    region  = data.aws_region.current.name
    bucket  = var.state_bucket
    key     = "${var.nickname}/${var.environment}/${data.aws_region.current.name}/shared.tfstate"
    profile = var.aws_profile
  }
}
