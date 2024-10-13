# Hugging Face ML Infrastructure

이 프로젝트는 AWS 인프라를 사용하여 Hugging Face 모델을 동적으로 실행하기 위한 Terraform 코드를 포함하고 있습니다.

## 프로젝트 구조

```
project-root/
│
├── terraform/           # Terraform 코드
│   ├── main.tf          # 주 설정 파일
│   ├── variables.tf     # 변수 정의
│   ├── outputs.tf       # 출력 정의
│   ├── provider.tf      # AWS 프로바이더 설정
│   │
│   └── modules/         # Terraform 모듈
│       ├── vpc/         # VPC 설정
│       ├── ec2/         # EC2 (GPU 인스턴스) 설정
│       ├── lambda/      # Lambda 함수 설정
│       └── s3/          # S3 버킷 설정
│
├── src/                 # 소스 코드
│   ├── lambda_function.py   # Lambda 함수 코드
│   └── ec2_startup_script.sh # EC2 시작 스크립트
│
├── models/              # ML 모델 파일 (S3에 업로드 예정)
│   └── README.md        # 모델 관리 설명
│
└── README.md            # 이 파일
```

## 사용 방법

1. AWS CLI를 설정하고 필요한 권한이 있는지 확인합니다.
2. Terraform을 설치합니다.
3. `terraform/` 디렉토리로 이동합니다.
4. `terraform init`을 실행하여 Terraform을 초기화합니다.
5. `terraform plan`을 실행하여 생성될 리소스를 확인합니다.
6. `terraform apply`를 실행하여 인프라를 생성합니다.
7. 생성된 S3 버킷에 Hugging Face 모델 파일을 업로드합니다.
8. Lambda 함수를 트리거하여 ML 작업을 시작합니다.

## 주의사항

- 이 인프라는 비용이 발생할 수 있는 리소스를 생성합니다. 사용하지 않을 때는 `terraform destroy`를 실행하여 리소스를 삭제하세요.
- 보안 설정을 신중히 검토하고 필요에 따라 조정하세요.
- 실제 운영 환경에서 사용하기 전에 충분한 테스트를 진행하세요.

## 라이센스

이 프로젝트는 [MIT 라이센스](LICENSE)하에 제공됩니다.