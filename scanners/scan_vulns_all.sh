#!/bin/bash
# Run OWASP ZAP quick scan for all sites listed in /etc/ngosec/sites.list
REPORTDIR=/var/ngosec/reports
mkdir -p "$REPORTDIR"
DATE=$(date +%F_%H%M)

while read -r site; do
  site=$(echo "$site" | xargs)
  [ -z "$site" ] && continue
  SAFE=$(echo "$site" | sed 's/https:\/\///; s/[^A-Za-z0-9._-]/_/g')
  /opt/zap/zap.sh -cmd -quickurl "$site" -quickout "$REPORTDIR/${SAFE}_zap_${DATE}.json" || true
done < /etc/ngosec/sites.list

echo "ZAP scans complete. Reports in $REPORTDIR"
