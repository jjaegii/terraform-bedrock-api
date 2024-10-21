provider "aws" {
  region = "ap-northeast-2"
}

# IAM 모듈 호출
module "iam" {
  source = "./modules/iam"
}

# Lambda 모듈 호출 (IAM 역할을 참조)
module "lambda" {
  source        = "./modules/lambda"
  role_arn      = module.iam.lambda_execution_role_arn  # IAM 모듈에서 출력된 ARN을 참조
  model_id      = "anthropic.claude-3-5-sonnet-20240620-v1:0"  # Bedrock 모델 ID
  lambda_zip    = "src/lambda_function_payload.zip"  # ZIP 파일 경로 설정
}

# API Gateway 모듈 호출
module "api_gateway" {
  source     = "./modules/api_gateway"
  lambda_arn = module.lambda.lambda_arn  # Lambda 모듈에서 출력된 ARN을 참조
}

# API Gateway 엔드포인트 출력
output "api_endpoint" {
  value = module.api_gateway.api_endpoint
}
