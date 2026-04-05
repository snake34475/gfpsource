const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:8080');

ws.on('open', () => {
  console.log('✅ Connected');
  
  // 测试 BRUISE 2003
  const bruiseData = { cmd: 2003, atkerID: 1, userID: 2, decHP: 100, hp: 900, skillID: 1001, type: 1, hitCount: 1 };
  ws.send(JSON.stringify(bruiseData));
  console.log('📤 Sent: BRUISE (2003)');
  
  // 测试 BUFF 2005
  setTimeout(() => {
    const buffData = { cmd: 2005, userID: 1, buffID: 1001, buffLv: 5, buffType: 1, duration: 300, state: 1 };
    ws.send(JSON.stringify(buffData));
    console.log('📤 Sent: BUFF (2005) add');
  }, 500);
  
  setTimeout(() => {
    const buffRemove = { cmd: 2005, userID: 1, buffID: 1001, buffLv: 5, buffType: 1, duration: 0, state: 2 };
    ws.send(JSON.stringify(buffRemove));
    console.log('📤 Sent: BUFF (2005) remove');
  }, 1000);
  
  setTimeout(() => { ws.close(); process.exit(0); }, 2000);
});

ws.on('message', (data) => {
  console.log('📥 Server:', data.toString());
});

ws.on('error', (err) => {
  console.error('❌ Error:', err.message);
});