import { metadata, storage } from './src/adapter/contextBroker'

var url = 'http://pep/v1'
var timeout = 3000 // ms
var cacheExpireTime = 15 * 1000 // ms

export default {
	debug: true,
	port: 3000,
	payloadMaxSize: '512kb',
	auth: {
		enabled: true,
		header: 'Authorization',
		byToken: true,
	},
	metadata: {
		method: metadata,
		url,
		timeout,
		cacheExpireTime,
	},
	storage: {
		method: storage,
		url,
		timeout,
		cacheExpireTime,
	},
}
