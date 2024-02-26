variable "aws_region" {
  description = "AWS Region to deploy to"
  default     = "us-east-2"
}

variable "distribution_pkg_folder" {
  description = "Folder name to create distribution files..."
  default = "./lambda_dist_pkg"
}

variable "source_dir" {
  description = "The directory containing the Lambda function code"
  default     = "./lambda"
}

variable "env_name" {
  description = "Name of the environment"
  default     = "lambda-test"
}

variable "lambda_policy" {
  description = "The policy for the Lambda function"
  type = list(string)
}

variable "function_name" {
  description = "Name of the Lambda function"
  default     = "change_my_name"
}

variable "lambda_runtime_handler" {
  description = "The runtime for the Lambda function"
  default     = "python3.8"
}

variable "lambda_function_handler" {
  description = "The handler for the Lambda function, in the form of 'filename.handler', e.g. 'index.handler' for index.js file with handler function 'handler'"
  default     = "index.handler"
}

variable "output_path" {
  description = "The path to the output file"
  default     = "/output/lambda.zip"
}