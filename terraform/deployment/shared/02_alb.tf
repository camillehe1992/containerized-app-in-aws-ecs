# https://registry.terraform.io/providers/hashicorp/aws/5.0.0/docs/resources/lb
resource "aws_lb" "this" {
  name               = "${var.nickname}-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  idle_timeout       = 60
  ip_address_type    = "ipv4"
  security_groups    = var.security_groups
  subnets            = var.alb_subnet_ids

  tags = var.tags
}
