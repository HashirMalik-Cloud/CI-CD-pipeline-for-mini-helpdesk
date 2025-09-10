# Unique suffix for bucket names
resource "random_id" "suffix" {
  byte_length = 2
}

# DynamoDB table for tickets
resource "aws_dynamodb_table" "tickets" {
  name         = "${var.project}-${var.env}-tickets"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Project = var.project
    Env     = var.env
  }
}

# S3 bucket for attachments (no public access)
resource "aws_s3_bucket" "attachments" {
  bucket = "${var.project}-${var.env}-attachments-${random_id.suffix.hex}"

  tags = {
    Project = var.project
    Env     = var.env
  }
}

resource "aws_s3_bucket_public_access_block" "attachments_block" {
  bucket                  = aws_s3_bucket.attachments.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
