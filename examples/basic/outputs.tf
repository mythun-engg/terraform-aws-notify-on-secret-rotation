output "sns_topic_arn" {
  value = module.notify_on_secret_rotation.sns_topic_arn
}

output "event_rule_arn" {
  value = module.notify_on_secret_rotation.event_rule_arn
}
