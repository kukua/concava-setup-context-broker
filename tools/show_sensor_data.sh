#!/bin/bash

# Get configuration
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE=$DIR/../.env
[ -f $ENV_FILE ] && . $ENV_FILE

# Show sensor data
(curl "$CONTEXTBROKER_HOST/v1/queryContext" -s -S --header 'Content-Type: application/json' \
    --header 'Accept: application/json' -d @- | python -mjson.tool) <<EOF
{
    "entities": [
        {
            "type": "SensorData",
            "isPattern": "true",
            "id": "${1:-0000000000000001-.*}"
        }
    ]
}
EOF
