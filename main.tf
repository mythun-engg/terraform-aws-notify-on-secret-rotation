data "aws_caller_identity" "current" {}

resource "aws_sns_topic_policy" "this" {
  arn = aws_sns_topic.this.arn
  policy = templatefile("${path.module}/policy-templates/sns-topic-policy.json.tpl", {
    sns_topic_arn = aws_sns_topic.this.arn
    rule_arn      = aws_cloudwatch_event_rule.this.arn
  })
}

resource "aws_sns_topic" "this" {
  name              = var.topic_name
  display_name      = coalesce(var.topic_display_name, var.topic_name)
  kms_master_key_id = var.kms_key_id
  tags              = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  for_each = toset(var.email_subscriptions)

  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_cloudwatch_event_rule" "this" {
  name        = var.rule_name
  description = var.rule_description

  event_pattern = local.effective_event_pattern_json
  tags          = var.tags
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "sns-topic"
  arn       = aws_sns_topic.this.arn
  role_arn  = aws_iam_role.eventbridge.arn

  input_transformer {
    input_paths = {
      account    = "$.account"
      region     = "$.region"
      time       = "$.time"
      secret_arn = "$.detail.additionalEventData.SecretId"
      secret_id  = "$.detail.additionalEventData.SecretId"
      event_name = "$.detail.eventName"
    }

    input_template = <<EOT
"Secrets Manager rotation succeeded for <secret_id> at <time> (account <account>, region <region>, event <event_name>)."
EOT
  }
}

resource "aws_iam_role" "eventbridge" {
  name               = var.eventbridge_role_name
  assume_role_policy = templatefile("${path.module}/policy-templates/eventbridge-assume-role.json.tpl", {})
  tags               = var.tags
}

resource "aws_iam_role_policy" "eventbridge_publish" {
  name = "eventbridge-sns-publish"
  role = aws_iam_role.eventbridge.id
  policy = templatefile("${path.module}/policy-templates/eventbridge-publish.json.tpl", {
    sns_topic_arn = aws_sns_topic.this.arn
  })
}
