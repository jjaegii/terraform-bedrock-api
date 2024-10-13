variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Availability Zones to use for the subnets"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

# variable "instance_type" {
#   description = "EC2 instance type for the GPU instance"
#   type        = string
#   default     = "g4dn.xlarge"
# }

variable "instance_type" {
  description = "EC2 instance type for the GPU instance"
  type        = string
  default     = "t2.micro" # 임시로 작은 인스턴스 유형 사용
}

variable "key_name" {
  description = "Name of the EC2 key pair to use"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to store ML models"
  type        = string
}

variable "huggingface_model_name" {
  description = "Name of the Hugging Face model to download and use"
  type        = string
  default     = "bert-base-uncased"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Environment = "ML-Infrastructure"
    Project     = "HuggingFace-ML"
    ManagedBy   = "Terraform"
  }
}

variable "create_key_pair" {
  description = "Whether to create a new key pair"
  type        = bool
  default     = false
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = ""
}