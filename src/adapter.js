import request from 'request'

var codeResponses = {
	401: 'Invalid token.',
	503: 'Context Broker unavailable.',
}
var query = (req, config, url, body, cb) => {
	request.post(config.url + '/' + url, {
		timeout: (config.timeout || 3000),
		headers: {
			'X-Auth-Token': req.auth.token,
			'Content-Type': 'application/json',
			'Accept': 'application/json',
		},
		body: JSON.stringify(body),
	}, (err, res, data) => {
		if (err) return cb(err)

		// Check response code
		var code = res.statusCode

		if (codeResponses[code]) {
			err = new Error(codeResponses[code])
			err.statusCode = code
			return cb(err)
		}

		// Handle response body
		data = JSON.parse(data)

		if (data.errorCode) {
			err = data.errorCode
			return cb(err.reasonPhrase + ' (' + err.code + '): ' + err.details)
		}

		cb(null, data)
	})
}

// Authentication
export let auth = (req, config, data, cb) => {
	cb('ContextBroker authentication will be done by the PEP proxy.')
}

// Authentication
var cache = {}

export let metadata = (req, config, data, { SensorData, SensorAttribute }, cb) => {
	if ( ! (data instanceof SensorData)) return cb('Invalid SensorData given.')

	var id = data.getDeviceId()

	// Check cache
	var cached = cache[id]

	if (cached && cached.timestamp > Date.now() - config.cacheExpireTime) {
		data.setAttributes(cached.attributes)
		return cb()
	}

	// Request from Context Broker
	query(req, config, 'queryContext', {
		entities: [
			{
				type: 'SensorMetadata',
				isPattern: 'false',
				id: id,
			},
		],
	}, (err, result) => {
		if (err) return cb(err)

		var attributes = []

		try {
			result = result.contextResponses[0].contextElement.attributes

			// Since the Context Broker doesn't keep the order of attributes, sort them by 'index' attribute
			result.forEach(function (item) {
				var index = 0

				if (item.metadatas) {
					item.metadatas.forEach(function (meta) {
						if (meta.name === 'index') {
							index = parseInt(meta.value)
						}
					})
				}

				item.index = index
			})

			result.sort((a, b) => a.index - b.index)

			// Parse into sensor attributes
			result.forEach(function (item) {
				var attr = new SensorAttribute()

				attr.setName(item.name)
				attr.addConverter(item.type, item.value)

				if (item.metadatas) {
					item.metadatas.forEach(function (meta) {
						if (meta.name === 'index') return
						if (meta.name === 'calibrate') {
							attr.addCalibrator(new Function('value', decodeURI(meta.value)))
						} else {
							attr.addValidator(meta.name, meta.value)
						}
					})
				}

				attributes.push(attr)
			})

			// Cache result
			cache[id] = {attributes, timestamp: Date.now()}

			// Callback
			data.setAttributes(attributes)
			cb()
		} catch (err) {
			cb(err)
		}
	})
}

// Storage
export let storage = (req, config, data, { SensorData }, cb) => {
	if ( ! (data instanceof SensorData)) return cb('Invalid SensorData given.')

	var values = data.getData()
	var attributes = []

	// Determine timestamp
	var timestamp = (new Date(values.timestamp).getTime() || Date.now())

	// Format attributes
	for (var name in values) {
		attributes.push({
			name,
			value: values[name],
		})
	}

	// Append timestamp as attribute
	attributes.push({ name: 'timestamp', value: '' + timestamp })

	// Insert sensor data
	query(req, config, 'updateContext', {
		contextElements: [
			{
				type: 'SensorData',
				id: data.getDeviceId() + '-' + timestamp,
				attributes: attributes,
			},
		],
		updateAction: 'APPEND_STRICT',
	}, (err, data) => {
		if (err) return cb(err)
		cb(null, data.contextResponses[0].contextElement.id)
	})
}
