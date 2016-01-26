#!/bin/bash

# Get configuration
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env
[ -f $ENV_FILE ] && . $ENV_FILE

# Get password
PASSWORD=$($DIR/get_token.sh idm ${1:-idm})

[ "$PASSWORD" = '' ] && echo 'Error retrieving admin password!' && exit 1

# Remove old tokens
sed -i '/KEYROCK_ADMIN_TOKEN=[a-zA-Z0-9]*/d' $ENV_FILE

echo "KEYROCK_ADMIN_TOKEN=$PASSWORD" >> $ENV_FILE
