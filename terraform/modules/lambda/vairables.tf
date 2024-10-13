variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the subnets to run the Lambda function in"
  type        = list(string)
}

variable "ec2_instance_id" {
  description = "ID of the EC2 instance to control"
  type        = string
}

variable "lambda_function_code" {
  description = "Path to the Lambda function source code file"
  type        = string
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
}