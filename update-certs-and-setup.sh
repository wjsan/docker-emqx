#!/bin/sh

set -e

DOMAIN="${DOMAIN}"
EMAIL="${EMAIL}"

SOURCE_DIR="/etc/letsencrypt/live/${DOMAIN}"
DEST_DIR="/certs"
LOCKFILE="/tmp/certbot.lock"

while :; do
    if [ ! -f "$LOCKFILE" ]; then
        touch $LOCKFILE
        certbot certonly --standalone --preferred-challenges http-01 -d ${DOMAIN} --email ${EMAIL} --agree-tos --non-interactive

        mkdir -p ${DEST_DIR}

        if [ -d "${SOURCE_DIR}" ]; then
            cp -L ${SOURCE_DIR}/* ${DEST_DIR}/
            chmod -R 755 ${DEST_DIR}
        fi

        rm $LOCKFILE
    else
        echo "Certbot is already running."
    fi

    sleep 12h
done