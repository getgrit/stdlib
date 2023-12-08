#!/bin/bash

# Retrieve client ID and secret from environment variables
CLIENT_ID=$(printenv API_CLIENT_ID)
CLIENT_SECRET=$(printenv API_CLIENT_SECRET)

# Check if CLIENT_ID and CLIENT_SECRET are set
if [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ]; then
    echo "API_CLIENT_ID or API_CLIENT_SECRET is not set."
    exit 1
fi

# Set the Auth0 Tenant Domain and API Audience
AUTH0_TENANT_DOMAIN="auth0.grit.io" # replace with your domain
AUTH0_API_AUDIENCE="https://api2.grit.io"   # replace with your API audience

# Making a POST request to get the token
RESPONSE=$(curl -s -X POST "https://$AUTH0_TENANT_DOMAIN/oauth/token" \
    -H "Content-Type: application/json" \
    -d "{\"client_id\":\"$CLIENT_ID\", \"client_secret\":\"$CLIENT_SECRET\", \"audience\":\"$AUTH0_API_AUDIENCE\", \"grant_type\":\"client_credentials\"}")

# Extracting the access token from the response
ACCESS_TOKEN=$(echo $RESPONSE | jq -r '.access_token')

# Check if ACCESS_TOKEN is retrieved
if [ -z "$ACCESS_TOKEN" ]; then
    echo "Failed to get access token."
    exit 1
else
    echo "GRIT_AUTH_TOKEN is set."
    # Echo the access token into GITHUB_ENV
    echo "GRIT_AUTH_TOKEN=$ACCESS_TOKEN" >> $GITHUB_ENV
fi
