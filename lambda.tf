provider "aws" {
  region = var.aws_region
}

resource "aws_kms_key" "a" {}
resource "aws_kms_alias" "lambda" {
  name          = "alias/lambda"
  target_key_id = aws_kms_key.a.key_id
}

resource "aws_lambda_permission" "cloudwatch_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_function.arn
}

resource "aws_lambda_function" "lambda_function" {
  handler = var.lambda_function_handler
  runtime = var.lambda_runtime_handler
  function_name = "${var.env_name}_${var.function_name}"

  role = aws_iam_role.lambda_exec_role.arn
  timeout = 300

  depends_on = [null_resource.install_python_dependencies]
  source_code_hash = data.archive_file.create_dist_pkg.output_base64sha256
  filename = data.archive_file.create_dist_pkg.output_path
}
