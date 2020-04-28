resource "aws_cloudwatch_log_group" "this" {
  name              = local.project_name-environment
  retention_in_days = 7
}
