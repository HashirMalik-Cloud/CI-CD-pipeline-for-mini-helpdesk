variable "frontend_bucket_name" {
  description = "Unique S3 bucket name for frontend hosting"
  type        = string
}

# Make sure var.env exists in your repo (you already have env usage elsewhere)
# provider configuration should already exist in your repo (aws provider)

resource "aws_s3_bucket" "frontend" {
  bucket        = var.frontend_bucket_name
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name = var.frontend_bucket_name
    Env  = var.env
  }
}

data "aws_iam_policy_document" "public_get_object" {
  statement {
    sid    = "AllowPublicReadGetObject"
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

# IAM user for GitHub Actions (limited permissions to this bucket)
data "aws_iam_policy_document" "ci_policy" {
  statement {
    sid = "ListBucket"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.frontend.arn]
  }
  statement {
    sid = "ObjectsAccess"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${aws_s3_bucket.frontend.arn}/*"]
  }
}

resource "aws_iam_user" "ci_user" {
  name = "github-actions-deployer-${var.env}"
}

resource "aws_iam_user_policy" "ci_user_policy" {
  name = "github-actions-s3-policy-${var.env}"
  user = aws_iam_user.ci_user.name
  policy = data.aws_iam_policy_document.ci_policy.json
}

resource "aws_iam_access_key" "ci_key" {
  user = aws_iam_user.ci_user.name
}

# Helpful outputs
output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend.id
}

output "frontend_website_endpoint" {
  value = aws_s3_bucket.frontend.website_endpoint
}

output "ci_access_key_id" {
  value     = aws_iam_access_key.ci_key.id
  sensitive = true
}

output "ci_secret_access_key" {
  value     = aws_iam_access_key.ci_key.secret
  sensitive = true
}
