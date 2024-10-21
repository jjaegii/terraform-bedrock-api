output "lambda_arn" {
  description = "Lambda 함수의 ARN"
  value       = aws_lambda_function.llm_inference.arn
}
