#!/bin/bash

# Get configuration
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env
[ -f $ENV_FILE ] && . $ENV_FILE

# Get token
curl -i -s \
	-H "Content-Type: application/json" \
	-d '
{ "auth": {
    "identity": {
      "methods": ["password"],
      "password": {
        "user": {
          "name": "'"${1:-idm}"'",
          "domain": { "id": "default" },
          "password": "'"${2:-idm}"'"
        }
      }
    }
  }
}' \
	http://$KEYROCK_HOST/v3/auth/tokens | grep 'X-Subject-Token' | awk '{ print $2 }' | tr -d '\r'
