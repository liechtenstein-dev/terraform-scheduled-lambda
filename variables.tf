variable "aws_region" {
  description = "AWS Region to deploy to"
  default     = "us-east-2"
}

variable "source_dir" {
  description = "The directory containing the Lambda function code"
  default     = "./lambda"
}

variable "env_name" {
  description = "Name of the environment"
  default     = "lambda-test"
}

variable "function_name" {
  description = "Name of the Lambda function"
  default     = "change_my_name"
}

variable "lambda_runtime_handler" {
  description = "The runtime for the Lambda function"
  default     = "python3.8"
}

variable "retention_in_days" {
  description = "Number of days to retain logs in CloudWatch"
  default     = 14
}

variable "lambda_environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {
    ACCOUNT_ID = "${data.aws_caller_identity.current.account_id}"
  }
}

variable "schedule_expression" {
  description = "The schedule expression for the CloudWatch Event Rule"
  default     = "rate(1 day)"
}

variable "lambda_function_handler" {
  description = "The handler for the Lambda function, in the form of 'filename.handler', e.g. 'index.handler' for index.js file with handler function 'handler'"
  default     = "index.handler"
}