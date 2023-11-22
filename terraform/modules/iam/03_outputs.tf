output "role" {
  value = {
    arn = aws_iam_role.this.arn
    id  = aws_iam_role.this.id
  }
}
