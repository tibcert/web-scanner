# NGO Security Monitoring (Non‑Docker)

![Status](https://img.shields.io/badge/status-ready-green) ![License](https://img.shields.io/badge/license-MIT-blue)

A complete, native Linux security monitoring system for NGOs. Uses free open-source tools: ClamAV, Maldet, WPScan, OWASP ZAP, Nikto, RKHunter, YARA, and optional Greenbone/OpenVAS.

## Contents

- `scanners/` — scan scripts for malware, WordPress, server and vulnerabilities
- `setup/` — installer and helper scripts
- `dashboard/` — optional Node.js dashboard to view reports
- `reports/` — generated scan outputs (HTML/TXT)
- `logs/` — scanner logs
- `docs/` — GitHub Pages docs-ready content
- `.github/workflows/ci.yml` — basic CI to lint scripts

## Quick start (Ubuntu 20.04 / 22.04)

1. Upload repository to your server.
2. Run the installer (requires sudo):
```bash
sudo bash setup/install_all.sh
```
3. Edit `/etc/ngosec/sites.list` and add one site per line (https://site1.org).
4. Run the initial full scan:
```bash
sudo bash scanners/run_all_scans.sh
```
5. (Optional) Start the dashboard:
```bash
cd dashboard
npm install
npm start
# open http://SERVER:3000
```

## Cron (created by installer)
- Daily malware scan (ClamAV + Maldet): 01:00
- Daily WPScan: 02:00
- Weekly Nikto + RKHunter: Sunday 03:00
- Weekly OWASP ZAP: Sunday 04:00

## Notes
- Keep API tokens (WPScan) in `/etc/ngosec/wpscan_token` (installer creates sample).
- Reports are saved in `/var/ngosec/reports` and logs in `/var/ngosec/logs`.
- Do **not** scan sites you do not own or have permission to test.

## License
MIT
