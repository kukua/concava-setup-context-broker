#!/bin/bash

# Get configuration
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env
[ -f $ENV_FILE ] && . $ENV_FILE

dc () {
	docker-compose -f "$DIR/../docker-compose.yml" $@
}

dc up -d

# Configure KeyRock IDM
sleep 2 # sec
docker exec -it concavacontextbroker_idm /bin/sh -c 'source /usr/local/bin/virtualenvwrapper.sh \
	&& workon idm_tools \
	&& fab keystone.database_create'
dc restart idm
sleep 2 # sec
docker exec -it concavacontextbroker_idm /bin/sh -c 'source /usr/local/bin/virtualenvwrapper.sh \
	&& workon idm_tools \
	&& fab keystone.populate'

"$DIR/add_admin_token.sh"    # Adds KEYROCK_ADMIN_TOKEN to .env
"$DIR/change_password.sh"    # Changes password to $KEYROCK_ADMIN_PASSWORD
"$DIR/create_project.sh"     # Adds KEYROCK_PROJECT_ID to .env
echo

"$DIR/create_user.sh" "$KEYROCK_USER_EMAIL" "$KEYROCK_USER_NAME" "$KEYROCK_USER_PASS"
echo

# Configure PEP proxy
dc restart pep
sleep 2 # sec
(docker logs concavacontextbroker_pep | grep -iq 'INFO: Server - Success authenticating PEP proxy.') \
	|| echo 'Error authenticating PEP proxy. Verify values in config.pep.js.'

echo
echo 'Done.'
