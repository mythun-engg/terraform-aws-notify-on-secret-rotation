terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "my-aws-profile"
}

module "notify_on_secret_rotation" {
  source = "../../"

  topic_name         = "sec-rotation-topic"
  topic_display_name = "Secret Rotation Alerts"
  kms_key_id         = "arn:aws:kms:us-east-1:123456789012:key/11111111-2222-3333-4444-555555555555"

  email_subscriptions = [
    "security@example.com",
    "cloud-ops@example.com"
  ]

  secret_arns = [
    "arn:aws:secretsmanager:us-east-1:123456789012:secret:prod/db-credentials-abc123",
    "arn:aws:secretsmanager:us-east-1:123456789012:secret:prod/api-key-def456"
  ]

  rule_name        = "secrets-rotation-succeeded"
  rule_description = "Notify on Secrets Manager rotation success."

  eventbridge_role_name = "eventbridge-sns-rotation-role"

  tags = {
    Environment = "prod"
    Owner       = "security"
    CostCenter  = "1234"
  }
}
