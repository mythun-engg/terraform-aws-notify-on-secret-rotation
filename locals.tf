locals {
  secret_arns_json = jsonencode(var.secret_arns)

  effective_event_pattern_json = var.event_pattern_json != null ? var.event_pattern_json : templatefile("${path.module}/policy-templates/event-pattern.json.tpl", {
    include_secret_filter = length(var.secret_arns) > 0
    secret_arns_json      = local.secret_arns_json
  })
}
