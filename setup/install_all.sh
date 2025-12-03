#!/bin/bash
set -e
echo "NGO Security Monitoring - Installer (non-docker)"
# Create directories
sudo mkdir -p /var/ngosec/{logs,reports,scans}
sudo chown -R $USER:$USER /var/ngosec
sudo chmod -R 750 /var/ngosec

# Install packages
echo "Installing required packages (apt-get)..."
sudo apt-get update
sudo apt-get install -y clamav clamav-daemon clamav-freshclam wget curl unzip ruby-full build-essential default-jre nikto rkhunter yara mailutils git

# Freshclam update
sudo systemctl stop clamav-freshclam || true
sudo freshclam || true
sudo systemctl enable --now clamav-freshclam || true

# Install Maldet
if [ ! -f /usr/local/sbin/maldet ]; then
  wget http://www.rfxn.com/downloads/maldetect-current.tar.gz -O /tmp/maldetect.tar.gz
  cd /tmp
  tar -xzf maldetect.tar.gz
  cd maldetect-*
  sudo ./install.sh
  cd /
fi

# WPScan
sudo gem install wpscan || true

# OWASP ZAP
if [ ! -d /opt/zap ]; then
  ZAPV=2.15.0
  wget https://github.com/zaproxy/zaproxy/releases/download/v${ZAPV}/ZAP_${ZAPV}_Linux.tar.gz -O /tmp/zap.tar.gz
  sudo tar -xzf /tmp/zap.tar.gz -C /opt
  sudo ln -sf /opt/ZAP_${ZAPV}/zap.sh /usr/local/bin/zap.sh
fi

# Create config files
sudo mkdir -p /etc/ngosec
echo "# Add one site per line (https://example.org)" | sudo tee /etc/ngosec/sites.list
echo "WPScan API token placeholder" | sudo tee /etc/ngosec/wpscan_token

# Copy scanner scripts to /usr/local/ngosec
sudo mkdir -p /usr/local/ngosec/scanners
sudo cp -r scanners/* /usr/local/ngosec/scanners/
sudo chmod +x /usr/local/ngosec/scanners/*.sh

# Setup cron jobs
(crontab -l 2>/dev/null; echo "0 1 * * * /usr/local/ngosec/scanners/scan_malware.sh /var/www/ >> /var/ngosec/logs/scan_malware.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/ngosec/scanners/scan_wordpress_all.sh >> /var/ngosec/logs/scan_wordpress.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "0 3 * * 0 /usr/local/ngosec/scanners/scan_server.sh >> /var/ngosec/logs/scan_server.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "0 4 * * 0 /usr/local/ngosec/scanners/scan_vulns_all.sh >> /var/ngosec/logs/scan_vulns.log 2>&1") | crontab -

echo "Installer finished. Edit /etc/ngosec/sites.list to add your sites."
