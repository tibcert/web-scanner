
# Architecture Diagram

```
+------------------+
| NGO Websites     |
+--------+---------+
         |
         v
+----------------------+
| Security Server      |
| - ClamAV             |
| - Maldet             |
| - WPScan             |
| - YARA               |
| - Nikto              |
| - OWASP ZAP          |
+----------------------+
         |
         v
+----------------------+
| Logs & Reports       |
+----------------------+
         |
         v
+----------------------+
| Dashboard (Optional) |
+----------------------+
```
