variable "topic_name" {
  description = "Name of the SNS topic."
  type        = string
}

variable "aws_region" {
  description = "AWS region for provider configuration."
  type        = string
  default     = "us-east-1"
}

variable "eventbridge_role_name" {
  description = "IAM role name used by EventBridge to publish to SNS."
  type        = string
  default     = "eventbridge-sns-publish"
}
variable "topic_display_name" {
  description = "Display name for the SNS topic."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS key ID or ARN to encrypt the SNS topic."
  type        = string
  default     = null
}

variable "email_subscriptions" {
  description = "Email addresses to subscribe to the SNS topic."
  type        = list(string)
  default     = []
}

variable "secret_arns" {
  description = "Secret ARNs to filter rotation/update events. Leave empty to match all secrets."
  type        = list(string)
  default     = []
}

variable "rule_name" {
  description = "Name of the EventBridge rule."
  type        = string
  default     = "secrets-rotation-notifications"
}

variable "rule_description" {
  description = "Description of the EventBridge rule."
  type        = string
  default     = "Notify on AWS Secrets Manager rotation success."
}

variable "event_pattern_json" {
  description = "Optional raw JSON string to override the default EventBridge event pattern."
  type        = string
  default     = null

  validation {
    condition     = var.event_pattern_json == null ? true : can(jsondecode(var.event_pattern_json))
    error_message = "event_pattern_json must be valid JSON."
  }
}

variable "tags" {
  description = "Tags to apply to created resources."
  type        = map(string)
  default     = {}
}
