#!/bin/bash
REPORTDIR=/var/ngosec/reports
OUT=/var/ngosec/reports/index.html
mkdir -p "$REPORTDIR"
cat > "$OUT" <<'HTML'
<!doctype html>
<html><head><meta charset="utf-8"><title>NGO Security Reports</title>
<link rel="stylesheet" href="style.css">
</head><body>
<h1>NGO Security Reports</h1>
<ul>
HTML

for f in $(ls -1 $REPORTDIR | sort -r); do
  if [[ "$f" == "index.html" ]]; then continue; fi
  echo "<li><a href='$f'>$f</a></li>" >> "$OUT"
done

cat >> "$OUT" <<'HTML'
</ul>
</body></html>
HTML

echo "Generated $OUT"
