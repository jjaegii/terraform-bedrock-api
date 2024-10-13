import boto3
import json
import os

ec2 = boto3.client('ec2')
ssm = boto3.client('ssm')

def lambda_handler(event, context):
    instance_id = os.environ['EC2_INSTANCE_ID']
    
    # EC2 인스턴스 시작
    ec2.start_instances(InstanceIds=[instance_id])
    
    # 인스턴스가 실행될 때까지 대기
    waiter = ec2.get_waiter('instance_running')
    waiter.wait(InstanceIds=[instance_id])
    
    # 입력 데이터 준비 (event에서 받아온다고 가정)
    input_data = json.dumps(event.get('input', {}))
    
    # SSM Run Command를 사용하여 EC2 인스턴스에서 스크립트 실행
    response = ssm.send_command(
        InstanceIds=[instance_id],
        DocumentName="AWS-RunShellScript",
        Parameters={'commands': [f'python3 /home/ubuntu/run_model.py \'{input_data}\'']}
    )
    
    command_id = response['Command']['CommandId']
    
    # 명령 실행 완료 대기
    waiter = ssm.get_waiter('command_executed')
    waiter.wait(CommandId=command_id, InstanceId=instance_id)
    
    # 결과 확인
    output = ssm.get_command_invocation(
        CommandId=command_id,
        InstanceId=instance_id
    )
    
    # EC2 인스턴스 중지
    ec2.stop_instances(InstanceIds=[instance_id])
    
    return {
        'statusCode': 200,
        'body': json.loads(output['StandardOutputContent'])
    }