#!/bin/bash
# Run all scans sequentially
sudo /usr/local/ngosec/scanners/scan_malware.sh /var/www
sudo /usr/local/ngosec/scanners/scan_wordpress_all.sh
sudo /usr/local/ngosec/scanners/scan_server.sh
sudo /usr/local/ngosec/scanners/scan_vulns_all.sh
echo "All scans triggered."
