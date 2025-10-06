#!/bin/bash

# Fetch the Slack webhook securely from SSM Parameter Store
SLACK_WEBHOOK=$(aws ssm get-parameter \
  --name "slack_notification_webhook" \
  --with-decryption \
  --region eu-west-2 \
  --query "Parameter.Value" \
  --output text)

# Check if the httpd process is running
if ! pgrep -x "httpd" > /dev/null; then
  MESSAGE=" ALERT: httpd process is not running!"

  # Send Slack alert
  curl -X POST -H 'Content-type: application/json' --data "{
    \"text\": \"$MESSAGE\"
  }" "$SLACK_WEBHOOK"
fi
