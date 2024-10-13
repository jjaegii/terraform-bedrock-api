import sys
import json
from transformers import pipeline

def run_model(input_data):
    # S3에서 모델을 다운로드했다고 가정합니다.
    # 실제로는 여기에 S3에서 모델을 다운로드하는 코드가 필요할 수 있습니다.

    # Huggingface pipeline 설정
    # 여기서는 예시로 텍스트 분류 모델을 사용합니다. 필요에 따라 변경하세요.
    classifier = pipeline("text-classification", model="distilbert-base-uncased-finetuned-sst-2-english")

    # 입력 데이터로 모델 실행
    result = classifier(input_data['text'])

    return result

if __name__ == "__main__":
    # 커맨드 라인 인자로 받은 JSON 문자열을 파싱
    input_data = json.loads(sys.argv[1])
    
    # 모델 실행
    output = run_model(input_data)
    
    # 결과 출력 (Lambda 함수에서 이를 캡처합니다)
    print(json.dumps(output))