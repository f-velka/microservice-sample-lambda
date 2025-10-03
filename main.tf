terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.60"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.4"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_iam_role" "lambda" {
  name = var.function_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  handler       = "lambda_function.handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda.arn
  architectures = ["arm64"]

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.arn
  authorization_type = "AWS_IAM"
  invoke_mode        = "BUFFERED"
  cors {
    allow_credentials = false
    allow_headers     = ["*"]
    allow_methods     = ["GET", "POST"]
    allow_origins     = ["*"]
    max_age           = 600
  }
}

output "function_name" {
  value       = aws_lambda_function.this.function_name
  description = "Name of the deployed Lambda function."
}

output "function_arn" {
  value       = aws_lambda_function.this.arn
  description = "ARN of the deployed Lambda function."
}

output "function_url" {
  value       = aws_lambda_function_url.this.function_url
  description = "Lambda Function URL secured with IAM."
}
