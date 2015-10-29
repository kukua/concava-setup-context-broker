# KeyRock IDM

> User authenticator for ConCaVa connectors and Orion Context Broker PEP proxy.

## How to use

```bash
docker-compose up -d
docker exec -it keyrockauth_idm_1 /bin/sh -c 'source /usr/local/bin/virtualenvwrapper.sh && workon idm_tools && fab keystone.database_create'
docker-compose restart
sleep 2
docker exec -it keyrockauth_idm_1 /bin/sh -c 'source /usr/local/bin/virtualenvwrapper.sh && workon idm_tools && fab keystone.populate'
echo "KEYROCK_IP=<container ip>" > .env # On OS X the IP address can be found in $DOCKER_HOST
echo "KEYROCK_IDM_PASSWORD=<new password>" >> .env
./tools/get_token.sh # Appends KEYROCK_IDM_TOKEN to .env
```

Next open `http://<container ip>:8000/` and login with username `idm` and password `idm`.

## Checklist

- [ ] Test on Windows and write scripts for it?

## Notes

- http://fiware-idm.readthedocs.org/en/latest/admin_guide.html
- http://docs.openstack.org/developer/keystone/api_curl_examples.html#projects
- http://developer.openstack.org/api-ref-identity-v3.html
