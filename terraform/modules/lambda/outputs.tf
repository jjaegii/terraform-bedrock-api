output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.ml_trigger.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.ml_trigger.arn
}