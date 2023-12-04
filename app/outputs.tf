# In your outputs.tf
output "lambda" {
  value = aws_lambda_function.helloworld # Ensure this matches the resource name
}

#output "apigateway" {
#  value = aws_api_gateway_rest_api.this
#}
