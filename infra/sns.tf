variable "sns_notification_email" {
  description = "Email address that should receive ticket notifications"
  type        = string
}

# Create SNS Topic
resource "aws_sns_topic" "ticket_notifications" {
  name = "${var.project}-${var.env}-ticket-notifications"
}

# Create SNS Subscription (email)
resource "aws_sns_topic_subscription" "ticket_email_subscription" {
  topic_arn = aws_sns_topic.ticket_notifications.arn
  protocol  = "email"
  endpoint  = var.sns_notification_email
}

# Outputs
output "sns_topic_arn" {
  value = aws_sns_topic.ticket_notifications.arn
}
