########################################
# Package Lambda code into a zip (from compiled JS)
########################################
data "archive_file" "tickets_zip" {
  type = "zip"

  # ✅ Changed: now look inside infra/backend-dist instead of ../backend/
  source_file = "${path.module}/backend-dist/tickets.js"

  output_path = "${path.module}/build/tickets.zip"
}

########################################
# Lambda execution role (assume role)
########################################
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "${var.project}-${var.env}-lambda-exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

########################################
# Inline policy for the Lambda (logs, DynamoDB, S3)
########################################
data "aws_iam_policy_document" "lambda_policy" {
  # CloudWatch logs
  statement {
    sid = "Logs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${var.aws_region}:*:*"]
  }

  # DynamoDB access for tickets table
  statement {
    sid = "DDB"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]
    resources = [aws_dynamodb_table.tickets.arn]
  }

  # S3 access for attachments bucket
  statement {
    sid = "S3"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.attachments.arn,
      "${aws_s3_bucket.attachments.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "lambda_inline" {
  name   = "${var.project}-${var.env}-lambda-policy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_inline.arn
}

########################################
# Lambda function resource
########################################
resource "aws_lambda_function" "tickets" {
  function_name = "${var.project}-${var.env}-tickets"
  role          = aws_iam_role.lambda_exec.arn

  filename         = data.archive_file.tickets_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.tickets_zip.output_path)

  runtime = "nodejs20.x"
  handler = "tickets.handler"

  timeout     = 10
  memory_size = 256

  environment {
    variables = {
      TICKETS_TABLE = aws_dynamodb_table.tickets.name
      ATTACH_BUCKET = aws_s3_bucket.attachments.bucket
      NODE_OPTIONS  = "--enable-source-maps"
    }
  }

  depends_on = [aws_iam_role_policy_attachment.attach]
}
