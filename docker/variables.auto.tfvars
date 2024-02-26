lambda_name = "api_lambda"
# it depends on what the lambda is actually doing
#lambda_environment_variables:
# ENV = "dev"
env_name = "dev"
function_handler = "index.handler"
runtime = "python3.8"
lambda_policy = [
 "ssm:DescribeInstanceInformation",
  "ssm:GetParameter",
  "ssm:GetParameters",
  "ssm:GetParametersByPath",
  "ssm:PutParameter",
  "ssm:DeleteParameter",
  "ssm:DeleteParameters",
  "ssm:UpdateInstanceInformation"
]
