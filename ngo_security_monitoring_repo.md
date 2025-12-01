# TIBCERT Website Security Monitoring — Full Guid

This repository provides a **complete, production‑ready security monitoring system** for NGOs managing many websites (WordPress, custom apps, static sites, PHP apps, etc.) without using Docker. Everything runs directly on a Linux server using native packages, cron jobs, Bash scripts, and lightweight Node.js/PHP tooling.

The guide is written so NGOs with limited technical staff can maintain strong security without expensive commercial services.

---

# 📌 Features

- 🔍 **Daily malware scans** (ClamAV + Maldet)
- 🛡️ **WordPress security scanning** (WPScan CLI)
- 🕸️ **Full website vulnerability scanning** (OWASP ZAP automation)
- 🔎 **Server vulnerability scanning** (Nikto + RKHunter)
- 🧬 **Custom YARA rules** to detect suspicious PHP/JS malware
- 🗂️ **Centralized logs** in `/var/log/ngosec/`
- 📧 **Daily & weekly email alerts**
- 🖥️ **Optional lightweight web dashboard** (Node.js) — non‑docker
- 🗓️ **Automated cron jobs** for all scanners

---

# 📁 Directory Structure

```
ngosec/
 ├── scanners/
 │    ├── scan_wordpress.sh
 │    ├── scan_malware.sh
 │    ├── scan_server.sh
 │    ├── scan_vulns.sh
 │    └── yara_rules/
 ├── logs/
 ├── reports/
 ├── dashboard/   # optional Node.js dashboard
 └── setup/
      └── install_all.sh
```

---

# 🚀 1. Installation Guide (Non‑Docker)

This section provides a complete, manual installation for all scanners.

## **1.1 System Requirements**

- Ubuntu 20.04 / 22.04 LTS (recommended)
- 1GB RAM minimum
- Python3, Node.js (optional dashboard)
- Mail server (or SMTP credentials)

---

# 🧰 2. Install All Security Tools

## **2.1 Install ClamAV**
```
sudo apt update
sudo apt install -y clamav clamav-daemon
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-daemon
```

## **2.2 Install Maldet (Linux Malware Detect)**
```
wget http://www.rfxn.com/downloads/maldetect-current.tar.gz
tar -xzvf maldetect-current.tar.gz
cd maldetect-*/
sudo ./install.sh
```

Enable ClamAV integration:
```
sudo sed -i 's/clamav_scan=0/clamav_scan=1/' /usr/local/maldetect/conf.maldet
sudo sed -i 's/quarantine_hits=0/quarantine_hits=1/' /usr/local/maldetect/conf.maldet
```

---

## **2.3 Install WPScan**
```
sudo apt install -y ruby ruby-dev build-essential
sudo gem install wpscan
```

NGOs: request more API credits here:  
https://wpscan.com/rgstr

---

## **2.4 Install OWASP ZAP (Automation Mode)**
```
wget https://github.com/zaproxy/zaproxy/releases/download/v2.15.0/ZAP_2.15.0_Linux.tar.gz
tar -xvzf ZAP_*.tar.gz
sudo mv ZAP* /opt/zap
```

---

## **2.5 Install Nikto**
```
sudo apt install nikto
```

---

## **2.6 Install RKHunter**
```
sudo apt install rkhunter
sudo rkhunter --update
sudo rkhunter --propupd
```

---

## **2.7 Install YARA**
```
sudo apt install yara
```

Add custom WordPress/PHP malware signatures in:
```
ngosec/scanners/yara_rules/*.yar
```

---

# 📝 3. Automated Scan Scripts (Non‑Docker)

All scripts run without containers. Only Bash + CLI tools.

## **3.1 scan_malware.sh**
Scans directories using ClamAV + Maldet + YARA.

```
#!/bin/bash
TARGET="$1"
LOG="/var/log/ngosec/malware_$(date +%F).log"

clamscan -ri "$TARGET" >> $LOG
maldet -a "$TARGET" >> $LOG
yara -r ngosec/scanners/yara_rules "$TARGET" >> $LOG
```

---

## **3.2 scan_wordpress.sh**
```
#!/bin/bash
SITE="$1"
LOG="/var/log/ngosec/wpscan_$(basename $SITE)_$(date +%F).log"

wpscan --url "$SITE" --enumerate ap,at,cb,dbe --api-token YOUR_TOKEN >> $LOG
```

---

## **3.3 scan_server.sh**
```
#!/bin/bash
LOG="/var/log/ngosec/server_$(date +%F).log"
nikto -h https://yourdomain.com >> $LOG
rkhunter --check --skip-keypress >> $LOG
```

---

## **3.4 scan_vulns.sh** (OWASP ZAP Automation)
```
#!/bin/bash
TARGET="$1"
/opt/zap/zap.sh -cmd -quickurl "$TARGET" -quickout "/var/log/ngosec/zap_$(date +%F).html"
```

---

# ⏲️ 4. Add Cron Jobs (Automation)

Edit cron:
```
sudo crontab -e
```

Add daily malware scanning:
```
0 1 * * * /usr/local/ngosec/scanners/scan_malware.sh /var/www/ >> /dev/null
```

Daily WordPress scanning:
```
0 2 * * * /usr/local/ngosec/scanners/scan_wordpress.sh https://site1.org
0 2 * * * /usr/local/ngosec/scanners/scan_wordpress.sh https://site2.org
```

Weekly server scan:
```
0 3 * * 0 /usr/local/ngosec/scanners/scan_server.sh
```

OWASP ZAP weekly scan:
```
0 4 * * 0 /usr/local/ngosec/scanners/scan_vulns.sh https://yourdomain.org
```

---

# 📬 5. Email Alerts

Install mailutils:
```
sudo apt install mailutils
```

Send latest scans via cron:
```
mail -s "NGO Daily Security Report" your@email.com < $(ls -t /var/log/ngosec/*.log | head -1)
```

---

# 📊 6. Optional Web Dashboard (Non‑Docker Node.js App)

### Install Node
```
sudo apt install -y nodejs npm
```

### Start Dashboard
```
cd ngosec/dashboard
npm install
npm start
```

Access at:
```
http://SERVER-IP:3000
```

Displays:
- last scans
- threat history
- charts  
- infected files

---

# 🔐 7. Hardening & Best Practices

- Enable automatic OS security updates  
- Use Cloudflare for WAF (free for NGOs)  
- Enforce 2FA everywhere  
- Disable password login, use SSH keys  
- Weekly backup snapshots

---

# 📗 8. Conclusion

This **non‑Docker** setup is ideal for NGOs that want:
- Full control over servers
- No container overhead
- Native OS-level security tooling

I can also generate:
✅ PDF version  
✅ A ZIP of this full repository  
✅ GitHub‑ready push commands

Just let me know!

