# KeyRock IDM

> User authenticator for ConCaVa connectors and Orion Context Broker PEP proxy.

## How to use

```bash
docker-compose up -d
docker exec -it keyrockauth_idm /bin/sh -c 'source /usr/local/bin/virtualenvwrapper.sh && workon idm_tools && fab keystone.database_create'
docker-compose restart idm
sleep 2 # seconds
docker exec -it keyrockauth_idm /bin/sh -c 'source /usr/local/bin/virtualenvwrapper.sh && workon idm_tools && fab keystone.populate'

# Configure KeyRock IDM
cp .env.sample .env
# > Manually configure the .env file

./tools/add_admin_token.sh # Adds KEYROCK_ADMIN_TOKEN to .env
./tools/change_password.sh # Changes password to $KEYROCK_ADMIN_PASSWORD
./tools/create_project.sh  # Adds KEYROCK_PROJECT_ID to .env
./tools/create_user.sh '<email>' '<username>' '<password>'

# Configure PEP
cp config/setting.py.example config/setting.py
# > Edit config/pep.js (at least account_host, username, and password)
# > Edit config/settings.py (should work out of the box)
docker-compose restart pep
docker-compose logs pep # Verify if running and authenticated
# "INFO: Server - Success authenticating PEP proxy. Proxy Auth-token: ..."
```

Next open `http://<container ip>:8000/` and login with username `idm` and password `idm`.

## Notes

- http://fiware-idm.readthedocs.org/en/latest/admin_guide.html
- http://docs.openstack.org/developer/keystone/api_curl_examples.html#projects
- http://developer.openstack.org/api-ref-identity-v3.html
