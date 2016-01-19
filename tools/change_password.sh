#!/bin/bash

# Get configuration
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env
[ -f $ENV_FILE ] && . $ENV_FILE

# Change password
curl \
	-H "X-Auth-Token: $KEYROCK_ADMIN_TOKEN" \
	-H "Content-Type: application/json" \
	-d '{ "user": {"password": "'"$KEYROCK_ADMIN_PASSWORD"'", "original_password": "idm"} }' \
	http://$KEYROCK_HOST/v3/users/idm/password

# Reset token
"$DIR/add_admin_token.sh" $KEYROCK_ADMIN_PASSWORD
