resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.env_name}_lambda_policy"
  description = "${var.env_name} - Lambda Policy"

  policy = <<-EOF
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
        "Action": [
          ${var.lambda_policy}
          "kms:ListAliases",
          "kms:Decrypt"
        ],
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
  }
  EOF
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
