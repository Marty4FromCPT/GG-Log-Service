#!/bin/bash

API_URL="https://7lrojtw9b9.execute-api.us-east-1.amazonaws.com/prod/submit"

for i in {1..200}
do
  response=$(curl -s -X POST "$API_URL" \
    -H "Content-Type: application/json" \
    -d "{\"severity\": \"info\", \"message\": \"Test log entry number $i\"}")

  log_msg=$(echo "$response" | jq -r '.log.message')
  log_time=$(echo "$response" | jq -r '.log.datetime')

  echo "[$i] ✅ $log_time - $log_msg"
done

