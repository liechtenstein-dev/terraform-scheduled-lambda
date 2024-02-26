# Scheduled Lambda Module
This Terraform module provides a solution for deploying and scheduling AWS Lambda functions. It leverages CloudWatch Events to establish flexible triggers, ensuring your functions execute.

### Inputs
| Variable Name                | Description                                                     | Default Value    |
|------------------------------|-----------------------------------------------------------------|------------------|
| aws_region                   | The AWS region for deployment.                                  | us-east-2        |
| source_dir                   | Path to the directory containing your Lambda code.              | ./lambda         |
| env_name                     | Prefix for naming resources, aiding in organization.             | lambda-test      |
| function_name                | The name of your Lambda function.                               | change_my_name   |
| lambda_runtime_handler       | Lambda runtime and handler (e.g., 'python3.8 index.handler').    | python3.8        |
| retention_in_days            | Duration (in days) for retaining CloudWatch Logs.               | 14               |
| lambda_environment_variables | Map of environment variables for the Lambda function.            | Includes AWS account ID |
| schedule_expression          | CloudWatch Event schedule expression (e.g., 'rate(1 day)', 'cron(0 12 * * ? *)'). | rate(1 day) |
| lambda_function_handler      | Lambda handler in the format 'filename.handler'                  | index.handler    |

### Outputs
*  lambda_arn: The ARN of the deployed Lambda function.

### Considerations

Package your Lambda code as a zip file within the source_dir.
Adapt input variables to suit your project's specifications.

Example
```
module "scheduled_lambda" {
  source               = "./modules/scheduled-lambda" 
  aws_region           = "us-west-2"
  source_dir           = "../my-lambda-function"
  env_name             = "prod"
  function_name        = "data_processing" 
  schedule_expression  = "cron(0 12 * * ? *)" 
}
```