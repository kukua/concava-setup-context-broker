# ConCaVa with Orion Context Broker, KeyRock IDM and PEP proxy

> This setup uses the KeyRock IDM + PEP proxy for authentication and the Context Broker for sensor (meta)data storage.

## Requirements

- [Docker](https://docs.docker.com/engine/installation/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## How to use

```bash
git clone https://github.com/kukua/concava-setup-mysql-influxdb
cd concava-setup-mysql-influxdb
cp .env.sample .env
# > Edit configuration in .env
docker-compose up -d

# Configure KeyRock IDM
docker exec -it concavacontextbroker_idm /bin/sh -c 'source /usr/local/bin/virtualenvwrapper.sh && workon idm_tools && fab keystone.database_create'
docker-compose restart idm
sleep 2 # seconds
docker exec -it concavacontextbroker_idm /bin/sh -c 'source /usr/local/bin/virtualenvwrapper.sh && workon idm_tools && fab keystone.populate'

./tools/add_admin_token.sh    # Adds KEYROCK_ADMIN_TOKEN to .env
./tools/change_password.sh    # Changes password to $KEYROCK_ADMIN_PASSWORD
./tools/create_project.sh     # Adds KEYROCK_PROJECT_ID to .env
./tools/create_user.sh '<email>' '<username>' '<password>'

# Configure PEP proxy
# > Edit config/pep.js (set same account_host, username, and password as in .env)
docker-compose restart pep
docker-compose logs pep       # Verify if running and authenticated
# "INFO: Server - Success authenticating PEP proxy. Proxy Auth-token: ..."

# Prepare Context Broker
./tools/append_sensor_metadata.sh
```

Now you will be able to open `http://<container ip>:8000/` and login with username `idm` and password `idm`.

Note: do not use in production without closing ports in `docker-compose.yml`.

## Test

```bash
# 1337 (base 10) = 00000539 (base 16)
echo '00000539' | xxd -r -p | \
	curl -i -XPUT 'http://<container IP>:3000/v1/sensorData/0000000000000001' \
	-H 'Authorization: Token abcdef0123456789abcdef0123456789' \
	-H 'Content-Type: application/octet-stream' --data-binary @-

docker-compose logs concava
./tools/show_sensor_data.sh
```

## Todo

- [ ] Put KeyRock IDM user info in `.env`
- [ ] Read KeyRock IDM user info from `.env` in `./tools/create_user.sh`
- [ ] Automate setup process
- [ ] Create script that syncs `.env` with config files. So that editing `config/pep.js` and `config/settings.py` is no longer necessary

## Notes

- http://fiware-idm.readthedocs.org/en/latest/admin_guide.html
- http://docs.openstack.org/developer/keystone/api_curl_examples.html#projects
- http://developer.openstack.org/api-ref-identity-v3.html
