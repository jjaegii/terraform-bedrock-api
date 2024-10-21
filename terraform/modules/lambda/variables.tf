variable "role_arn" {
  description = "IAM 역할의 ARN"
  type        = string
}

variable "model_id" {
  description = "Bedrock 모델 ID"
  type        = string
  default     = "anthropic.claude-3-5-sonnet-20240620-v1:0"  # 기본값 설정
}

variable "lambda_zip" {
  description = "Lambda zip 파일 경로"
  type        = string
  default     = "lambda_function_payload.zip"  # ZIP 파일 경로를 모듈의 상대 경로로 설정
}
