#!/bin/sh

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env

[ -f $ENV_FILE ] && source $ENV_FILE

# TODO(mauvm): Remove old token from $ENV_FILE

curl -i -s \
  -H "Content-Type: application/json" \
  -d '
{ "auth": {
    "identity": {
      "methods": ["password"],
      "password": {
        "user": {
          "name": "idm",
          "domain": { "id": "default" },
          "password": "'${1:-idm}'"
        }
      }
    }
  }
}' \
	http://$KEYROCK_HOST:5000/v3/auth/tokens | tee /dev/tty \
	| grep 'X-Subject-Token' | awk '{ print "KEYROCK_IDM_TOKEN="$2 }' | tr -d '\r' >> $ENV_FILE
