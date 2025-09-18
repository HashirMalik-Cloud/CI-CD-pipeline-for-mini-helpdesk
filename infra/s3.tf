variable "frontend_bucket_name" {
  description = "Unique S3 bucket name for frontend hosting"
  type        = string
}

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
    sid       = "AllowPublicReadGetObject"
    actions   = ["s3:GetObject"]
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

# IAM user for GitHub Actions (restricted to this bucket)
data "aws_iam_policy_document" "ci_policy" {
  statement {
    sid       = "ListBucket"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.frontend.arn]
  }
  statement {
    sid = "ObjectsAccess"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.frontend.arn}/*"]
  }
}

resource "aws_iam_user" "ci_user" {
  name = "github-actions-deployer-${var.env}"
}

resource "aws_iam_user_policy" "ci_user_policy" {
  name   = "github-actions-s3-policy-${var.env}"
  user   = aws_iam_user.ci_user.name
  policy = data.aws_iam_policy_document.ci_policy.json
}

resource "aws_iam_access_key" "ci_key" {
  user = aws_iam_user.ci_user.name
}

# Outputs
output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend.id
}

output "frontend_website_endpoint" {
  value = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "ci_access_key_id" {
  value     = aws_iam_access_key.ci_key.id
  sensitive = true
}

output "ci_secret_access_key" {
  value     = aws_iam_access_key.ci_key.secret
  sensitive = true
}
