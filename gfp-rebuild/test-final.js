const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:8080', { 
  handshakeTimeout: 5000,
  maxPayload: 1024 * 1024
});

let responseLog = [];

ws.on('open', () => {
  console.log('✅ Connected to ws://localhost:8080\n');
  
  // 测试 1: 登录
  const loginData = { cmd: 10001, username: "test", password: "123456" };
  ws.send(JSON.stringify(loginData));
  console.log('📤 [TEST 1] Sent LOGIN (10001)');
  
  // 测试 2: 伤害协议 BRUISE 2003
  setTimeout(() => {
    const bruiseData = { cmd: 2003, atkerID: 1, userID: 2, decHP: 100, hp: 900, skillID: 1001, type: 1, hitCount: 1 };
    ws.send(JSON.stringify(bruiseData));
    console.log('📤 [TEST 2] Sent BRUISE (2003) - 伤害协议');
  }, 500);
  
  // 测试 3: Buff 添加
  setTimeout(() => {
    const buffData = { cmd: 2005, userID: 1, buffID: 1001, buffLv: 5, buffType: 1, duration: 300, state: 1 };
    ws.send(JSON.stringify(buffData));
    console.log('📤 [TEST 3] Sent BUFF (2005) - 添加Buff');
  }, 1000);
  
  // 测试 4: Buff 移除
  setTimeout(() => {
    const buffRemove = { cmd: 2005, userID: 1, buffID: 1001, buffLv: 5, buffType: 1, duration: 0, state: 2 };
    ws.send(JSON.stringify(buffRemove));
    console.log('📤 [TEST 4] Sent BUFF (2005) - 移除Buff');
  }, 1500);
  
  setTimeout(() => {
    console.log('\n=== Test Complete ===');
    ws.close();
    process.exit(0);
  }, 2500);
});

ws.on('message', (data) => {
  const msg = data.toString();
  console.log('📥 [RECEIVED]', msg.substring(0, 200));
});

ws.on('error', (err) => {
  console.error('❌ WebSocket Error:', err.message);
});

ws.on('close', (code, reason) => {
  console.log('🔌 Disconnected, code:', code);
});