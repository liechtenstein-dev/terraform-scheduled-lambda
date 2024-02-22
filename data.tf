data "archive_file" "lambda_function_zip" {
  source_dir  = var.source_dir
  output_path = "/tmp/lambda.zip"
  type        = "zip"
}

data "aws_caller_identity" "current" {}