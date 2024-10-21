import os
import boto3
import json

def handler(event, context):
    # Bedrock 클라이언트 생성
    client = boto3.client('bedrock-runtime')
    
    # 모델 ID 및 프롬프트 가져오기
    model_id = os.environ['MODEL_ID']  # 환경 변수에서 모델 ID 가져오기

    # API Gateway로부터 전달된 event에서 요청 본문 가져오기
    try:
        request_body = json.loads(event.get("body", "{}"))
    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json; charset=utf-8'
            },
            'body': json.dumps({"error": "Invalid JSON in request body"})
        }

    # 사용자가 제공한 프롬프트 확인, 없으면 기본 프롬프트 사용
    prompt = request_body.get("prompt", "Describe the purpose of a 'hello world' program in one line.")
    
    # Bedrock에 보낼 요청 본문 구성 (Claude 모델 구조)
    body = {
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": 512,
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": prompt  # 사용자의 프롬프트 전달
                    }
                ]
            }
        ]
    }
    
    # Bedrock에 모델 호출 요청
    try:
        response = client.invoke_model(
            modelId=model_id,
            contentType='application/json',
            accept='application/json',
            body=json.dumps(body)
        )
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json; charset=utf-8'
            },
            'body': json.dumps({"error": str(e)})
        }
    
    # StreamingBody에서 응답 데이터 읽기 및 디코딩
    response_body = response['body'].read().decode('utf-8')
    
    # 응답 JSON 디코딩
    model_response = json.loads(response_body)
    
    # Claude 모델 응답에서 텍스트 추출
    if "content" in model_response and len(model_response["content"]) > 0:
        response_text = model_response["content"][0]["text"]
    else:
        response_text = "No text content found in the response."
    
    # 최종 결과 반환 (API Gateway와 호환되는 형식으로)
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json; charset=utf-8'  # UTF-8 인코딩 명시
        },
        'body': json.dumps({"response": response_text}, ensure_ascii=False)  # ensure_ascii=False로 한글 처리
    }
