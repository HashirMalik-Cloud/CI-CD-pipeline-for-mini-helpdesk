variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type    = string
  default = "mini-helpdesk"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "frontend_bucket_name" {
  description = "Unique S3 bucket name for frontend hosting"
  type        = string
  default     = "mini-helpdesk-frontend-dev-01" # ✅ Your actual bucket name
}
