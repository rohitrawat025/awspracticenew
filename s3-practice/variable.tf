

variable "bucket_name" {
  description = "S3 bucket name for application logs"
  type        = string
}

variable "log_uploader_role_name" {
  description = "IAM role allowed to upload logs"
  type        = string
}



