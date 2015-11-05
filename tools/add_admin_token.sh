#!/bin/sh

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env

if [ -f $ENV_FILE ]; then
	source $ENV_FILE
fi

PASSWORD=$($DIR/get_token.sh idm ${1:-idm})

if [[ $PASSWORD != '' ]]; then
	# Remove old tokens
	sed -i '' '/KEYROCK_ADMIN_TOKEN=[a-zA-Z0-9]*/d' $ENV_FILE

	echo "KEYROCK_ADMIN_TOKEN=$PASSWORD" >> $ENV_FILE
else
	echo 'Error retrieving admin password!'
fi
