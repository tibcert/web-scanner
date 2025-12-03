#!/bin/bash
# Read sites from /etc/ngosec/sites.list and run WPScan for each
SITELIST=/etc/ngosec/sites.list
LOGDIR=/var/ngosec/logs
REPORTDIR=/var/ngosec/reports
mkdir -p "$LOGDIR" "$REPORTDIR"
DATE=$(date +%F_%H%M)
TOKEN_FILE=/etc/ngosec/wpscan_token
API_TOKEN=""
if [ -f "$TOKEN_FILE" ]; then
  API_TOKEN=$(cat "$TOKEN_FILE" | tr -d '\n')
fi

while read -r site; do
  site=$(echo "$site" | xargs)
  [ -z "$site" ] && continue
  SAFE=$(echo "$site" | sed 's/https:\/\///; s/[^A-Za-z0-9._-]/_/g')
  OUT="$REPORTDIR/${SAFE}_wpscan_${DATE}.txt"
  if [ -n "$API_TOKEN" ]; then
    wpscan --url "$site" --api-token "$API_TOKEN" --enumerate vp,vt,tt --disable-tls-checks --random-user-agent > "$OUT" 2>&1 || true
  else
    wpscan --url "$site" --enumerate vp,vt,tt --disable-tls-checks --random-user-agent > "$OUT" 2>&1 || true
  fi
done < "$SITELIST"
echo "WPScan complete. Reports in $REPORTDIR"
