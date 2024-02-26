
variable "function_handler" {
  description = "The name of the function handler"
  type        = string
}

variable "runtime" {
  description = "The runtime of the lambda function"
  type        = string
}
variable "env_name" {
  description = "The name of the environment"
  type        = string
}
variable "lambda_policy" {
  description = "The list of policies to attach to the lambda role"
  type        = list(string)
}
variable "lambda_name" {
  description = "The name of the lambda function"
  type        = string
}
variable "region" {
  description = "The region where the lambda function will be deployed"
  type        = string
  default = "us-east-2"
}
resource "aws_ecr_repository" "lambda_image" {
  name = "lambda-image"
}

resource "null_resource" "docker_build" {
  provisioner "local-exec" {
    command = <<-EOF
    aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${aws_ecr_repository.lambda_image.repository_url}
    docker build -t ${aws_ecr_repository.lambda_image.name} .
    docker tag ${aws_ecr_repository.lambda_image.name}:latest ${aws_ecr_repository.lambda_image.repository_url}:latest
    docker push ${aws_ecr_repository.lambda_image.repository_url}:latest
    EOF
    working_dir = "${path.module}/lambda"

  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

data "aws_ecr_image" "image" {
  repository_name = aws_ecr_repository.lambda_image.name
  image_tag = "latest"
  depends_on = [ null_resource.docker_build ]
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_name
  runtime = var.runtime
  role = aws_iam_role.lambda_role.arn
  # Usar la imagen construida localmente
  image_uri = "${aws_ecr_repository.lambda_image.repository_url}:${data.aws_ecr_image.image.image_tag}"
  package_type = "Image"
  depends_on = [null_resource.docker_build]
}

output "lambda_function_arn" {
  value = aws_lambda_function.lambda_function.arn
}


resource "aws_kms_key" "a" {}
resource "aws_kms_alias" "lambda" {
  name          = "alias/lambda"
  target_key_id = aws_kms_key.a.key_id
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.env_name}_lambda_policy"
  description = "${var.env_name} - Lambda Policy"

  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "kms:ListAliases",
          "kms:Decrypt"
        ],
        "Effect": "Allow",
        "Resource": "${aws_kms_alias.lambda.arn}"
        },
        {
        "Action": concat(var.lambda_policy, ["kms:ListAliases","kms:Decrypt"]),
        "Effect": "Allow",
        "Resource": "*"
        },
        {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role" "lambda_role" {
  name = "app_${var.env_name}_lambda_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}
