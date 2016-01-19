#!/bin/bash

# Get configuration
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env
[ -f $ENV_FILE ] && . $ENV_FILE

# Authenticate
curl -i -s \
	-H "Content-Type: application/json" \
	-H "X-Auth-Token: $KEYROCK_ADMIN_TOKEN" \
	-H "X-Subject-Token: $1" \
	http://$KEYROCK_HOST/v3/auth/tokens
