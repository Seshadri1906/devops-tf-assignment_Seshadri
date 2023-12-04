provider "aws" {
  region                      = "ap-southeast-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"

  endpoints {
    lambda        = "http://localhost:4566"
    apigateway    = "http://localhost:4566"
    iam           = "http://localhost:4566"
    // Add other endpoints for LocalStack as needed.
  }
}

resource "random_string" "this" {
  length  = 16
  special = false
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

# ... rest of your lambda.tf content ...

# In your lambda.tf or wherever you are defining the Lambda function

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/nodejs"
  output_path = "${path.module}/${local.lambda_zip_name}"
}

resource "aws_iam_role" "lambda_role" {
  name = "${local.function_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_lambda_function" "helloworld" {
  function_name = local.function_name
  handler       = "index.handler"  # Update to your handler location
  role          = aws_iam_role.lambda_role.arn
  runtime       = "nodejs18.x"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      EXAMPLE_VARIABLE = "example-value" // Replace with actual environment variables.
    }
  }
}

resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.helloworld.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:ap-southeast-1:123456789012:api_id/*/GET/helloworld"
  // Make sure to replace the source_arn with the actual API Gateway ARN when it's created.
}
