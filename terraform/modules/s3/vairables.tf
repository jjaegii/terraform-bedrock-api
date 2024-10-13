variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
}