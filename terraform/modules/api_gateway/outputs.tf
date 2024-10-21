output "api_endpoint" {
  description = "API Gateway의 엔드포인트 URL"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}
