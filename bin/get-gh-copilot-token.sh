#!/bin/bash

# https://github.com/Aider-AI/aider/issues/2227#issuecomment-2869404979

CLIENT_ID='Iv23ctfURkiMfJ4xr5mv'
COMMON_HEADERS=(
  -H 'accept: application/json'
  -H 'content-type: application/json'
  -H 'accept-encoding: gzip,deflate,br'
)

# Step 1: Request device and user codes
echo "Requesting device and user codes..."
DEVICE_CODE_RESPONSE=$(curl -s --compressed -X POST \
  "${COMMON_HEADERS[@]}" \
  -d "{\"client_id\":\"$CLIENT_ID\",\"scope\":\"read:user\"}" \
  https://github.com/login/device/code)

DEVICE_CODE=$(echo "$DEVICE_CODE_RESPONSE" | jq -r '.device_code')
USER_CODE=$(echo "$DEVICE_CODE_RESPONSE" | jq -r '.user_code')
VERIFICATION_URI=$(echo "$DEVICE_CODE_RESPONSE" | jq -r '.verification_uri')

if [ "$DEVICE_CODE" == "null" ] || [ "$USER_CODE" == "null" ] || [ "$VERIFICATION_URI" == "null" ]; then
    echo "Error: Could not parse device code response."
    echo "$DEVICE_CODE_RESPONSE"
    exit 1
fi

echo "Please visit $VERIFICATION_URI and enter code $USER_CODE to authenticate."

# Step 2: Poll for access token
ACCESS_TOKEN="null"
echo "Polling for access token..."
while [ "$ACCESS_TOKEN" == "null" ]; do
  # wait 5 seconds between polls, unless a different interval is specified later
  CURRENT_POLL_INTERVAL=5
  sleep $CURRENT_POLL_INTERVAL

  TOKEN_RESPONSE=$(curl -s --compressed -X POST \
    "${COMMON_HEADERS[@]}" \
    -d "{\"client_id\":\"$CLIENT_ID\",\"device_code\":\"$DEVICE_CODE\",\"grant_type\":\"urn:ietf:params:oauth:grant-type:device_code\"}" \
    https://github.com/login/oauth/access_token)

  CURL_EXIT_CODE=$?
  if [ $CURL_EXIT_CODE -ne 0 ]; then
    echo "Error: Access token request failed during polling with curl exit code $CURL_EXIT_CODE."
    # Optionally, you might want to check the error from TOKEN_RESPONSE here
    # For now, we'll just continue polling or let the user interrupt
    continue
  fi

  if [ -z "$TOKEN_RESPONSE" ]; then
    echo "Error: Empty response from token request during polling."
    continue
  fi

  if ! echo "$TOKEN_RESPONSE" | jq -e . > /dev/null 2>&1; then
    echo "Error: Token response is not valid JSON during polling."
    echo "Raw response: $TOKEN_RESPONSE"
    continue
  fi

  # Check for errors in the response before trying to parse access_token
  ERROR=$(echo "$TOKEN_RESPONSE" | jq -r '.error')
  if [ "$ERROR" != "null" ] && [ "$ERROR" != "authorization_pending" ]; then
      ERROR_DESCRIPTION=$(echo "$TOKEN_RESPONSE" | jq -r '.error_description')
      echo "Error received from token endpoint: $ERROR_DESCRIPTION"
      # Depending on the error, you might want to exit or handle it differently
      # For "slow_down", we should respect the interval provided
      # Default to 5 if interval not present or not a number
      INTERVAL=$(echo "$TOKEN_RESPONSE" | jq -r '.interval')
      if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]] || [ "$INTERVAL" -le 0 ]; then
          echo "Warning: Invalid or non-positive interval '$INTERVAL' received. Defaulting to 5 seconds for slow_down."
          INTERVAL=5
      fi
      echo "Slowing down... waiting $INTERVAL seconds."
      CURRENT_POLL_INTERVAL=$INTERVAL # This will be used by sleep at the start of the loop
      # The actual sleep for "slow_down" will happen here before continuing
      sleep "$INTERVAL"
      continue
  fi

  ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')
  # If access_token is still "null" (as a string from jq -r), it means it wasn't found or was literally null
  # The loop condition `while [ "$ACCESS_TOKEN" == "null" ]` will handle this.
done

echo "Authentication success: $ACCESS_TOKEN"

echo "Testing Token..."

curl -s "https://api.githubcopilot.com/chat/completions" \
-X POST \
-H "Content-Type: application/json" \
-H "Copilot-Integration-Id: vscode-chat" \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-d '{
    "model": "gpt-4.1",
    "messages": [
      {"role": "user", "content": "Answer with \"OK it worked\""}
    ]
}' | jq -r '.choices[0].delta.content'
