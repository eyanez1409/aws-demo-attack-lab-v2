resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.deployment_name}-${random_string.unique_id.result}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "analysis_lambda" {
  # lambda have plain text secrets in environment variables
  filename      = "${path.root}/resources/lambda_function_payload.zip"
  function_name = "${var.deployment_name}-${random_string.unique_id.result}"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.lambda_handler"

  source_code_hash = filebase64sha256("${path.root}/resources/lambda_function_payload.zip")

  runtime = "python3.8"

  environment {
    variables = {
      access_key = "AKIAIOSFODNN7EXAMPLE2"
      secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    }
  }
}