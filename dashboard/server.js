const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
const REPORT_DIR = process.env.REPORT_DIR || '/var/ngosec/reports';
app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));
app.use('/static', express.static(path.join(__dirname, 'static')));

app.get('/', (req, res) => {
  fs.readdir(REPORT_DIR, (err, files) => {
    if (err) return res.status(500).send('Reports directory not available: ' + err);
    const reports = files.filter(f => f !== 'index.html').sort().reverse();
    res.render('index', { reports });
  });
});

app.get('/report/:name', (req, res) => {
  const name = req.params.name;
  const file = path.join(REPORT_DIR, name);
  if (!fs.existsSync(file)) return res.status(404).send('Not found');
  const ext = path.extname(file).toLowerCase();
  if (ext === '.html') {
    res.sendFile(file);
  } else {
    const content = fs.readFileSync(file, 'utf8');
    res.render('report', { name, content });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Dashboard listening on ${PORT}`));
