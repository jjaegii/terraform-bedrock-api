import os
import sys
import boto3
from transformers import AutoModel, AutoTokenizer

def download_and_upload_model(model_name, bucket_name):
    # 로컬에 모델 다운로드
    print(f"Downloading model: {model_name}")
    model = AutoModel.from_pretrained(model_name)
    tokenizer = AutoTokenizer.from_pretrained(model_name)

    # 로컬에 모델 저장
    local_model_path = f"./tmp/{model_name}"
    model.save_pretrained(local_model_path)
    tokenizer.save_pretrained(local_model_path)

    # S3에 업로드
    s3 = boto3.client('s3')
    print(f"Uploading model to S3 bucket: {bucket_name}")
    for root, dirs, files in os.walk(local_model_path):
        for file in files:
            local_path = os.path.join(root, file)
            s3_path = os.path.relpath(local_path, local_model_path)
            s3.upload_file(local_path, bucket_name, f"{model_name}/{s3_path}")

    print("Upload complete")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python download_and_upload_model.py <model_name> <bucket_name>")
        sys.exit(1)
    
    model_name = sys.argv[1]
    bucket_name = sys.argv[2]
    download_and_upload_model(model_name, bucket_name)