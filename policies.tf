resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.env_name}_delete_old_amis_lambda_function"
  description = "${var.env_name}_delete_old_amis_lambda_function"

  policy = <<EOF
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
    "ec2:DescribeImages",
    "ec2:DescribeSnapshotAttribute",
    "ec2:DescribeSnapshots",
    "ec2:DeleteSnapshot",
    "ec2:DescribeImages",
    "ec2:DescribeImageAttribute",
    "ec2:DeregisterImage",
    "ec2:DescribeInstances",
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

resource "aws_iam_role_policy_attachment" "delete_old_amis" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}
