# API Gateway 생성
resource "aws_apigatewayv2_api" "http_api" {
  name          = "llm_inference_api"
  protocol_type = "HTTP"
}

# Lambda와 API Gateway 통합
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_arn  # Lambda 모듈에서 제공한 ARN 사용
}

# API 경로 설정
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# API 배포 단계 설정
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true

  # 로그 설정
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format          = jsonencode({
      requestId          = "$context.requestId",
      ip                 = "$context.identity.sourceIp",
      requestTime        = "$context.requestTime",
      httpMethod         = "$context.httpMethod",
      routeKey           = "$context.routeKey",
      status             = "$context.status",
      protocol           = "$context.protocol",
      responseLength     = "$context.responseLength",
      integrationStatus  = "$context.integrationStatus"
    })
  }
}

# CloudWatch 로그 그룹 생성
resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/apigatewayv2/logs"
  retention_in_days = 7
}

# API Gateway가 Lambda 함수를 호출할 수 있는 권한 부여
resource "aws_lambda_permission" "allow_apigateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn  # Lambda ARN을 변수로 받아 사용
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}