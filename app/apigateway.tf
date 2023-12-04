resource "aws_api_gateway_rest_api" "this" {
  name        = "helloworld-localstack"
  description = "API for HelloWorld Lambda function"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "helloworld"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = aws_api_gateway_resource.api_resource.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.helloworld.invoke_arn
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.api_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "api_method"
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.helloworld.function_name
  principal     = "apigateway.amazonaws.com"
  // The source ARN here should match the invocation URL of the deployed API stage and resource
  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/${aws_api_gateway_deployment.this.stage_name}/POST/helloworld-localstack"
}

# API Key and Usage Plan resources remain the same

# Task C: Use Custom Domain
resource "aws_api_gateway_api_key" "helloworld_localstack_test" {
  name = "helloworld-localstack-test"
  description = "API key for the helloworld API"
  enabled = true
}

resource "aws_api_gateway_usage_plan" "helloworld_usage_plan" {
  name = "helloworld-usage-plan"
  description = "Usage plan for helloworld API"
  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_deployment.this.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "helloworld_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.helloworld_localstack_test.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.helloworld_usage_plan.id
}

# Existing resources from your apigateway.tf
# ...

# Task D: Use Custom Domain
resource "aws_api_gateway_domain_name" "helloworld_custom_domain" {
  domain_name = "helloworld.myapp.earth"

  # Assuming you have a certificate in ACM for your custom domain
  certificate_arn = "arn:aws:acm:REGION:ACCOUNT_ID:certificate/CERTIFICATE_ID"
}

resource "aws_api_gateway_base_path_mapping" "helloworld_base_path_mapping" {
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_deployment.this.stage_name
  domain_name = aws_api_gateway_domain_name.helloworld_custom_domain.domain_name

  # base_path is optional and used when you want to map a custom path to your API.
  # If you want to map the root path, you don't need to set this parameter.
  # base_path = "" # Uncomment if you want to map the root path
}
