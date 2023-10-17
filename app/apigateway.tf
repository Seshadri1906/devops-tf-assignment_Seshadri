#resource "aws_lambda_permission" "this" {
#  statement_id  = "AllowExecutionFromAPIGateway"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.this.function_name
#  principal     = "apigateway.amazonaws.com"
#
#  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
#}

# TO FILL IN resources, including but not limited to
# - aws_api_gateway_rest_api
# - aws_api_gateway_method
# - aws_api_gateway_deployment
