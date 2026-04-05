const fs = require('fs');
const WebSocket = require('ws');

const logFile = fs.createWriteStream('test-log.txt', { flags: 'w' });

function log(...args) {
  const msg = args.join(' ') + '\n';
  logFile.write(msg);
  console.log(...args);
}

const ws = new WebSocket('ws://localhost:8081');

ws.on('open', () => {
  log('=== 连接测试 ===');
  ws.send(JSON.stringify({ cmd: 10001 }));
  log('📤 LOGIN');
  
  setTimeout(() => {
    ws.send(JSON.stringify({ cmd: 2003, atkerID: 1, userID: 2, decHP: 100 }));
    log('📤 BRUISE 2003');
  }, 200);
  
  setTimeout(() => {
    ws.send(JSON.stringify({ cmd: 2005, userID: 1, buffID: 1001, state: 1 }));
    log('📤 BUFF add 2005');
  }, 400);
  
  setTimeout(() => {
    ws.send(JSON.stringify({ cmd: 2005, userID: 1, buffID: 1001, state: 2 }));
    log('📤 BUFF remove 2005');
    ws.close();
    logFile.end();
    setTimeout(() => process.exit(0), 100);
  }, 600);
});

ws.on('message', (data) => {
  log('📥 Server:', data.toString().substring(0, 100));
});