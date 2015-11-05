#!/bin/sh

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env

[ -f $ENV_FILE ] && source $ENV_FILE

ID=$(curl \
	-H "X-Auth-Token: $KEYROCK_ADMIN_TOKEN" \
	-H "Content-Type: application/json" \
	-d '
{
	"project": {
		"name": "'"$KEYROCK_PROJECT_NAME"'",
		"description": "'"$KEYROCK_PROJECT_DESC"'"
	}
}' \
	http://$KEYROCK_IP:5000/v3/projects | tee /dev/tty \
	| sed '/"id":/!d;s/^.*"id": "//;s/",.*$//')

if [[ $ID != '' ]]; then
	echo "KEYROCK_PROJECT_ID=$ID" >> $ENV_FILE
	echo $ID
fi
