#!/bin/bash
# Server vulnerability checks (Nikto + RKHunter)
LOGDIR=/var/ngosec/logs
REPORTDIR=/var/ngosec/reports
mkdir -p "$LOGDIR" "$REPORTDIR"
DATE=$(date +%F_%H%M)

# Nikto against hostnames in sites list
while read -r site; do
  site=$(echo "$site" | xargs)
  [ -z "$site" ] && continue
  SAFE=$(echo "$site" | sed 's/https:\/\///; s/[^A-Za-z0-9._-]/_/g')
  nikto -h "$site" -output "$REPORTDIR/${SAFE}_nikto_${DATE}.txt" || true
done < /etc/ngosec/sites.list

# RKHunter system scan
rkhunter --update
rkhunter --check --sk --rwo > "$REPORTDIR/rkhunter_${DATE}.txt" 2>&1 || true

echo "Server scans complete. Reports in $REPORTDIR"
