resource "aws_lambda_permission" "cloudwatch_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_function.arn
}

resource "aws_lambda_function" "lambda_function" {
  filename         = data.archive_file.lambda_function_zip.output_path
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
  function_name    = "${var.env_name}_${var.function_name}"
  role             = aws_iam_role.lambda_role.arn
  handler          = var.lambda_function_handler
  runtime          = var.lambda_runtime_handler
  timeout          = 900

  environment {
    variables = var.lambda_environment_variables
  }
}
