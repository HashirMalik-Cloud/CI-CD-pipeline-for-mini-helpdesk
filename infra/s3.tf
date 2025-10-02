# Create S3 bucket (no ACLs, uses bucket policy instead)
resource "aws_s3_bucket" "frontend" {
  bucket        = var.frontend_bucket_name
  force_destroy = true

  tags = {
    Name = var.frontend_bucket_name
    Env  = var.env
  }
}

# Configure ownership controls (required to allow bucket policy instead of ACLs)
resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Public access block (disable to allow website public access via bucket policy)
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

# Website configuration (replaces deprecated `website` block)
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Public bucket policy (allow anyone to GET objects)
data "aws_iam_policy_document" "public_get_object" {
  statement {
    sid     = "AllowPublicReadGetObject"
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.frontend.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.public_get_object.json
}

# Outputs
output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend.id
}

output "frontend_website_endpoint" {
  value = aws_s3_bucket_website_configuration.frontend.website_endpoint
}
