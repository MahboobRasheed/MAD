const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs');

const DATA_FILE = './data.json';

function readData() {
  try {
    return JSON.parse(fs.readFileSync(DATA_FILE));
  } catch (e) { return []; }
}
function writeData(data) { fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2)); }

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get('/activities', (req, res) => {
  const data = readData();
  res.json(data);
});

app.post('/activities', (req, res) => {
  const activity = req.body;
  const data = readData();
  data.push(activity);
  writeData(data);
  res.status(201).json(activity);
});

app.delete('/activities/:id', (req, res) => {
  const id = req.params.id;
  let data = readData();
  data = data.filter(a => a.id !== id);
  writeData(data);
  res.json({deleted: id});
});

const PORT = 3000;
app.listen(PORT, () => console.log('Mock API running on port', PORT));
