#!/bin/bash

# 시스템 업데이트 및 필요한 패키지 설치
sudo apt-get update
sudo apt-get install -y python3-pip awscli

# Python 패키지 설치
pip3 install torch transformers

# S3에서 모델 다운로드 (필요한 경우)
# aws s3 cp s3://your-bucket-name/model.pkl /home/ubuntu/model.pkl

# run_model.py 스크립트 다운로드 (S3에서 가져오거나, 사용자 데이터로 제공)
# aws s3 cp s3://your-bucket-name/run_model.py /home/ubuntu/run_model.py

# 스크립트에 실행 권한 부여
chmod +x /home/ubuntu/run_model.py

# CloudWatch Agent 설치 및 구성 (로깅을 위해)
sudo apt-get install -y amazon-cloudwatch-agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-linux

echo "EC2 인스턴스 설정 완료"