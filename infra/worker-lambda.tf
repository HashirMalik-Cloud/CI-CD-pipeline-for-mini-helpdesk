resource "aws_iam_role" "worker_lambda_role" {
  name = "${var.project}-${var.env}-worker-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "worker_lambda_policy" {
  name = "${var.project}-${var.env}-worker-lambda-policy"
  role = aws_iam_role.worker_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = aws_sns_topic.ticket_notifications.arn
      },
      {
        Effect   = "Allow"
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = aws_sqs_queue.ticket_queue.arn
      }
    ]
  })
}

# Automatically package the Lambda code into a zip file
data "archive_file" "worker_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/build/worker-lambda"
  output_path = "${path.module}/build/worker-lambda.zip"
}

resource "aws_lambda_function" "worker" {
  function_name = "${var.project}-${var.env}-worker"
  role          = aws_iam_role.worker_lambda_role.arn
  runtime       = "nodejs20.x"
  handler       = "index.handler"

  # Use the generated zip file
  filename         = data.archive_file.worker_lambda_zip.output_path
  source_code_hash = data.archive_file.worker_lambda_zip.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.ticket_notifications.arn
    }
  }
}

# Connect SQS -> Lambda
resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn = aws_sqs_queue.ticket_queue.arn
  function_name    = aws_lambda_function.worker.arn
  batch_size       = 1
  enabled          = true
}
