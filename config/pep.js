var config = {};

config.pep_port = 80;

// Set this var to undefined if you don't want the server to listen on HTTPS
config.https = undefined; /*{
    enabled: false,
    cert_file: 'cert/cert.crt',
    key_file: 'cert/key.key',
    port: 443
};*/

config.account_host = 'http://localhost';

config.keystone_host = 'idm';
config.keystone_port = 5000;

config.app_host = 'context_broker';
config.app_port = 1026;
// Use true if the app server listens in https
config.app_ssl = false;

// Credentials obtained when registering PEP Proxy in Account Portal
config.username = 'idm';
config.password = 'verysecurepassword';

// in seconds
config.chache_time = 300;

// if enabled PEP checks permissions with AuthZForce GE.
// only compatible with oauth2 tokens engine
config.azf = {
	enabled: false,
    host: 'auth.lab.fiware.org',
    port: 6019,
    path: '/authzforce/domains/d698df7f-ffd4-11e4-a09d-ed06f24e1e78/pdp'
};

// list of paths that will not check authentication/authorization
// example: ['/public/*', '/static/css/']
config.public_paths = [];

// options: oauth2/keystone
config.tokens_engine = 'keystone';

config.magic_key = undefined;

module.exports = config;
