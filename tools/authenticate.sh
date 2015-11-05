#!/bin/sh

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env

if [ -f $ENV_FILE ]; then
	source $ENV_FILE
fi

curl -i -s \
	-H "Content-Type: application/json" \
	-H "X-Auth-Token: $KEYROCK_ADMIN_TOKEN" \
	-H "X-Subject-Token: $1" \
	http://$KEYROCK_IP:5000/v3/auth/tokens
