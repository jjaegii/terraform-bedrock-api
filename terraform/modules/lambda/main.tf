# Lambda 함수 생성
resource "aws_lambda_function" "llm_inference" {
  function_name = "llm_inference"
  role          = var.role_arn  # IAM 모듈에서 생성된 역할 ARN 참조
  handler       = "inference.handler"
  runtime       = "python3.9"
  filename      = var.lambda_zip  # Lambda 함수 배포 zip 파일 경로
  timeout       = 30

  environment {
    variables = {
      MODEL_ID = var.model_id  # 사용할 Bedrock 모델 ID
    }
  }
}
