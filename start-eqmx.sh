#!/bin/bash

CERT_PATH="${EMQX_LISTENERS__SSL__DEFAULT__SSL_OPTIONS__CERTFILE}"
KEY_PATH="${EMQX_LISTENERS__SSL__DEFAULT__SSL_OPTIONS__KEYFILE}"

# Function to start EMQX
start_emqx() {
    echo "Start EMQX..."
    emqx start
}

# Monitor for changes
inotifywait -m -e modify "$CERT_PATH" "$KEY_PATH" |
while read path action file; do
    echo "Detected new certificate. Restarting EMQX..."
    emqx stop
    start_emqx
done &

# Start EMQX initially if not already running
if [ -f "$CERT_PATH" ] && [ -f "$KEY_PATH" ]; then
    start_emqx
fi

# Keep script running
while true; do
    sleep 60
done