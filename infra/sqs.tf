variable "tickets_queue_name" {
  description = "Name of the SQS queue for tickets"
  type        = string
  default     = "mini-helpdesk-dev-tickets-queue"
}

variable "tickets_dlq_name" {
  description = "Name of the Dead Letter Queue for failed tickets"
  type        = string
  default     = "mini-helpdesk-dev-tickets-dlq"
}

# Dead Letter Queue for failed messages
resource "aws_sqs_queue" "tickets_dlq" {
  name                       = var.tickets_dlq_name
  visibility_timeout_seconds = 30
  message_retention_seconds  = 1209600 # 14 days
}

# Main tickets queue
resource "aws_sqs_queue" "ticket_queue" {
  name                       = var.tickets_queue_name
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600 # 4 days

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.tickets_dlq.arn
    maxReceiveCount     = 5
  })

  tags = {
    Name = var.tickets_queue_name
    Env  = var.env
  }
}

# Outputs
output "tickets_queue_url" {
  value = aws_sqs_queue.ticket_queue.id
}

output "tickets_queue_arn" {
  value = aws_sqs_queue.ticket_queue.arn
}
