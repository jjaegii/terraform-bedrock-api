output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.gpu_instance.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.gpu_instance.public_ip
}