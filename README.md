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
# > Edit config/pep.js (set same account_host and admin password as in .env)

./tools/setup.sh
./tools/append_sensor_metadata.sh
```

Now you will be able to open `http://<container IP>:3003/` and login with username `idm` and admin password from `.env`.

__Note:__ do not use in production without closing ports in `docker-compose.yml`.

## Test

```bash
# 1337 (base 10) = 00000539 (base 16)
source .env
./tools/get_token.sh "$KEYROCK_USER_NAME" "$KEYROCK_USER_PASS"
echo '00000539' | xxd -r -p | \
	curl -i -XPUT 'http://<container IP>:3000/v1/sensorData/0000000000000001' \
	-H 'Authorization: Token <token from get_token.sh output>' \
	-H 'Content-Type: application/octet-stream' --data-binary @-

docker-compose logs concava
./tools/show_sensor_data.sh
```

## Todo

- [x] Automate setup process
- [x] Put KeyRock IDM user info in `.env`
- [x] Read KeyRock IDM user info from `.env` in `./tools/create_user.sh`
- [ ] Create script that syncs `.env` with config files. So that editing `config/pep.js` and `config/settings.py` is no longer necessary

## Notes

- http://fiware-idm.readthedocs.org/en/latest/admin_guide.html
- http://docs.openstack.org/developer/keystone/api_curl_examples.html#projects
- http://developer.openstack.org/api-ref-identity-v3.html
