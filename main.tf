provider "aws" {
  region = var.aws_region
}

locals {
  cloud_watch_event_rule_name = "${var.env_name}-cloudwatch-event-rule"
}

resource "aws_kms_key" "a" {}
resource "aws_kms_alias" "lambda" {
  name          = "alias/lambda"
  target_key_id = aws_kms_key.a.key_id
}

resource "aws_cloudwatch_event_rule" "lambda_function" {
  name                = local.cloud_watch_event_rule_name
  description         = "${var.env_name} - CloudWatch Event Rule"
  schedule_expression = var.schedule_expression
  state = var.state
}

resource "aws_cloudwatch_event_target" "cw_event_target" {
  rule      = aws_cloudwatch_event_rule.lambda_function.name
  target_id = "lambda"
  arn       = aws_lambda_function.lambda_function.arn
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = var.retention_in_days
}