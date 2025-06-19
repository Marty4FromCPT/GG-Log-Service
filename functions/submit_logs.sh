#!/bin/bash

API_URL="https://912fh3apo4.execute-api.us-east-1.amazonaws.com/prod/submit"

for i in {1..200}
do
  response=$(curl -s -X POST "$API_URL" \
    -H "Content-Type: application/json" \
    -d "{\"severity\": \"info\", \"message\": \"Test log entry number $i\"}")

  message=$(echo "$response" | jq -r '.log.message')
  datetime=$(echo "$response" | jq -r '.log.datetime')

  echo "[$i] ✅ $datetime - $message"
done
