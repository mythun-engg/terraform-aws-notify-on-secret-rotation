{
  "source": ["aws.secretsmanager"],
  "$or": [
    { "detail-type": ["AWS API Call via CloudTrail"] },
    { "detail-type": ["AWS Service Event via CloudTrail"] }
  ],
  "detail": {
    "eventSource": ["secretsmanager.amazonaws.com"],
    "eventName": ["RotationSucceeded"],
    "eventType": ["AwsServiceEvent"]
%{ if include_secret_filter }
    ,"additionalEventData": {
      "SecretId": ${secret_arns_json}
    }
%{ endif }
  }
}
