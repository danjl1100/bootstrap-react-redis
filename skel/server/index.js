// adapted from source: https://www.twilio.com/blog/react-app-with-node-js-server-proxy
const express = require('express');
const bodyParser = require('body-parser');
const pino = require('express-pino-logger')();

const MODE_DEPLOYED = !module.parent;

const app = express();
app.use(bodyParser.urlencoded({ extended: false }));
if(MODE_DEPLOYED) {
  app.use(pino);
}

app.get('/api/greeting', (req, res) => {
  const name = req.query.name || 'World';
  res.setHeader('Content-Type', 'application/json');
  res.send(JSON.stringify({ greeting: `Hello ${name}!` }));
});

//

const redis = require('redis');
client = redis.createClient('//redis:6379');
client.on('error', (err) => {
  console.log('Redis Error: ' + err);
});

if(MODE_DEPLOYED) {
  app.use(pino);
  app.listen(3001, () =>
    console.log('Express server is running on localhost:3001')
  );
}

// export App and Redis client for use in tests
module.exports = app;
module.exports.redis_client = client;
