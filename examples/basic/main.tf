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
  region = "us-east-1"
}

module "notify_on_secret_rotation" {
  source = "../../"

  topic_name = "secret-rotation-topic"

  email_subscriptions = [
    "security@example.com"
  ]

  secret_arns = [
    "arn:aws:secretsmanager:us-east-1:123456789012:secret:prod/db-credentials-abc123"
  ]

  tags = {
    Environment = "dev"
    Owner       = "security"
  }
}
