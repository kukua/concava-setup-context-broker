#!/bin/bash

# Get configuration
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env
[ -f $ENV_FILE ] && . $ENV_FILE

# Check project ID
if [ "$KEYROCK_PROJECT_ID" = '' ]; then
	echo "KEYROCK_PROJECT_ID missing from env file. Run ./tools/create_project.sh first."
	exit 1;
fi

# Create user
curl \
	-H "X-Auth-Token: $KEYROCK_ADMIN_TOKEN" \
	-H "Content-Type: application/json" \
	-d '
{
    "user": {
        "default_project_id": "'"$KEYROCK_PROJECT_ID"'",
        "email": "'"$1"'",
        "name": "'"$2"'",
        "password": "'"$3"'",
        "enabled": true
    }
}' \
	"http://$KEYROCK_HOST/v3/users"
