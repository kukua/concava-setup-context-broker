#!/bin/sh

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env

[ -f $ENV_FILE ] && source $ENV_FILE

curl \
 -H "X-Auth-Token: $KEYROCK_IDM_TOKEN" \
 -H "Content-Type: application/json" \
 -d '{ "user": {"password": "'$KEYROCK_IDM_PASSWORD'", "original_password": "idm"} }' \
 http://$KEYROCK_HOST:5000/v3/users/idm/password

# Reset token
$DIR/get_token.sh $KEYROCK_IDM_PASSWORD
