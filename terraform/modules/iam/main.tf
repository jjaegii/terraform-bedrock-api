# IAM 역할 생성 - Lambda가 Bedrock을 호출할 수 있도록 권한 부여
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role_jjaegii"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Lambda 역할에 Bedrock 호출 권한 부여
resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "bedrock:InvokeModel"  # Bedrock 모델을 호출하는 권한
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",   # 로그 그룹 생성 권한
          "logs:CreateLogStream",  # 로그 스트림 생성 권한
          "logs:PutLogEvents"      # 로그 데이터 쓰기 권한
        ],
        Resource = "arn:aws:logs:*:*:*"  # CloudWatch Logs에 대한 권한
      }
    ]
  })
}
