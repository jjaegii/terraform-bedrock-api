output "lambda_execution_role_arn" {
  description = "Lambda IAM 역할의 ARN"
  value       = aws_iam_role.lambda_execution_role.arn
}
