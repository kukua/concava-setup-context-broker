#!/bin/bash

# Get configuration
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env
[ -f $ENV_FILE ] && . $ENV_FILE

# Create project
ID=$(curl \
	-i -s \
	-H "X-Auth-Token: $KEYROCK_ADMIN_TOKEN" \
	-H "Content-Type: application/json" \
	-d '
{
	"project": {
		"name": "'"$KEYROCK_PROJECT_NAME"'",
		"description": "'"$KEYROCK_PROJECT_DESC"'"
	}
}' \
	"http://$KEYROCK_HOST/v3/projects" | tee /dev/tty \
	| sed '/"id":/!d;s/^.*"id": "//;s/",.*$//')

[ "$ID" = '' ] && echo 'Error determining project ID!' && exit 1

echo "KEYROCK_PROJECT_ID=$ID" >> $ENV_FILE
