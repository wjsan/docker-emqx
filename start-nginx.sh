#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
FULL="${CERT_DIR}/fullchain.pem"
KEY="${CERT_DIR}/privkey.pem"

# helper: compute a fingerprint for a file
file_fingerprint() {
  file="$1"
  if [ ! -f "$file" ]; then
    echo "MISSING"
    return
  fi
  if command -v md5sum >/dev/null 2>&1; then
    md5sum "$file" | awk '{print $1}'
    return
  fi
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$file" | awk '{print $1}'
    return
  fi
  # fallback: use file size + mtime
  if command -v stat >/dev/null 2>&1; then
    stat -c "%s-%Y" "$file" 2>/dev/null || ls -l --time-style=+%s "$file" 2>/dev/null | awk '{print $5"-"$6}'
    return
  fi
  ls -l "$file" 2>/dev/null | awk '{print $5"-"$6}'
}

# Start nginx via the official entrypoint so templates are processed
# Run it in background so the watcher loop can run in this container
if [ -x "/docker-entrypoint.sh" ]; then
  echo "[start-nginx] starting nginx via /docker-entrypoint.sh"
  /docker-entrypoint.sh nginx &
else
  echo "[start-nginx] /docker-entrypoint.sh not found, starting nginx directly"
  nginx &
fi

# wait until certs appear at least once (but don't block indefinitely)
count=0
while [ $count -lt 30 ]; do
  if [ -f "$FULL" ] && [ -f "$KEY" ]; then
    break
  fi
  count=$((count+1))
  sleep 1
done

last_full=$(file_fingerprint "$FULL")
last_key=$(file_fingerprint "$KEY")

echo "[start-nginx] initial full fingerprint: $last_full"
echo "[start-nginx] initial key fingerprint:  $last_key"

# monitor loop
while true; do
  sleep 10
  new_full=$(file_fingerprint "$FULL")
  new_key=$(file_fingerprint "$KEY")
  if [ "$new_full" != "$last_full" ] || [ "$new_key" != "$last_key" ]; then
    echo "[start-nginx] certificate change detected. Reloading nginx..."
    nginx -s reload || echo "[start-nginx] nginx reload failed"
    last_full="$new_full"
    last_key="$new_key"
  fi
done
