# Terraform AWS Bedrock AI Inference Architecture

## 개요
이 Terraform 프로젝트는 **AWS API Gateway**를 통해 **Lambda 함수**를 호출하고, **AWS Bedrock Claude 3.5** 모델에 요청을 보내어 AI 예측을 수행하는 인프라를 배포합니다. **CloudWatch Logs**는 Lambda 실행 로그를 기록하며, **IAM Role**은 API Gateway와 Lambda 간의 권한을 관리합니다.

## 아키텍처

- **API Gateway**: HTTP 요청을 수신하고 Lambda 함수를 호출합니다.
- **Lambda**: API Gateway에서 받은 요청을 처리하고 Bedrock 모델을 호출합니다.
- **AWS Bedrock**: Claude 3.5 모델을 사용해 AI 예측을 수행합니다.
- **CloudWatch Logs**: Lambda 함수의 실행 로그를 기록합니다.
- **IAM Role**: API Gateway가 Lambda를 호출할 수 있는 권한, Lambda가 CloudWatch와 Bedrock에 접근할 수 있는 권한을 관리합니다.

## 사용 방법

### 1. 사전 요구 사항
- [Terraform](https://www.terraform.io/downloads.html)이 설치되어 있어야 합니다.
- AWS CLI가 설정되어 있어야 합니다.
- AWS 계정이 필요합니다.

### 2. 배포

1. 이 저장소를 클론합니다:

   ```bash
   git clone <저장소 URL>
   cd terraform-sagemaker-api/terraform_new
   ```

2. Terraform 모듈을 초기화합니다:

   ```bash
   terraform init
   ```

3. Terraform 배포를 시작합니다:

   ```bash
   terraform apply
   ```

4. API Gateway의 엔드포인트 URL을 확인하려면 `terraform apply` 명령이 완료된 후 출력되는 `api_endpoint` 값을 확인하십시오.

### 3. 테스트

배포가 완료되면, 제공된 API Gateway URL을 사용하여 **POST** 요청을 보낼 수 있습니다. 예를 들어, 다음과 같은 `curl` 명령으로 테스트할 수 있습니다:

```bash
curl -X POST https://{api_endpoint} \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Explain the theory of relativity."}'
```

### 4. 정리

Terraform으로 배포한 리소스를 정리하려면 다음 명령을 사용합니다:

```bash
terraform destroy
```

## 파일 구조

```
terraform
├── main.tf                     # Root module for calling submodules
├── modules
│   ├── api_gateway
│   │   ├── main.tf             # API Gateway and integration with Lambda
│   │   ├── outputs.tf          # Outputs for API Gateway
│   │   └── variables.tf        # Variables for API Gateway module
│   ├── iam
│   │   ├── main.tf             # IAM Role and Policies for Lambda
│   │   └── outputs.tf          # Outputs for IAM Role
│   └── lambda
│       ├── main.tf             # Lambda Function definition
│       ├── outputs.tf          # Outputs for Lambda
│       └── variables.tf        # Variables for Lambda module
└── src
    ├── inference.py             # Lambda function source code
    └── lambda_function_payload.zip # Zipped Lambda function
```

## 주의 사항

- 이 인프라는 **AWS 요금**이 발생할 수 있습니다. 배포된 리소스는 사용 후 반드시 정리(`terraform destroy`)하시기 바랍니다.
- Lambda 함수에서 **AWS Bedrock 모델**을 호출하므로 **AI 모델 사용 요금**이 발생할 수 있습니다.
