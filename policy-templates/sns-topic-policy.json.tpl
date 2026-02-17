{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowEventBridgePublish",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "${sns_topic_arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${rule_arn}"
        }
      }
    }
  ]
}
