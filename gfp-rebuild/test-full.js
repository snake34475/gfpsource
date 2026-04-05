const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:8080', {
  followRedirects: true
});

ws.on('open', () => {
  console.log('=== 连接到服务器 ===\n');
  
  // 测试 1: 登录
  ws.send(JSON.stringify({ cmd: 10001, username: "test", password: "123456" }));
  console.log('📤 [1] LOGIN');
  
  // 测试 2: 伤害
  setTimeout(() => {
    ws.send(JSON.stringify({ cmd: 2003, atkerID: 1, userID: 2, decHP: 100, hp: 900, skillID: 1001, type: 1, hitCount: 1 }));
    console.log('📤 [2] BRUISE (2003) - 伤害协议已发送');
  }, 500);
  
  // 测试 3: Buff添加
  setTimeout(() => {
    ws.send(JSON.stringify({ cmd: 2005, userID: 1, buffID: 1001, buffLv: 5, buffType: 1, duration: 300, state: 1 }));
    console.log('📤 [3] BUFF (2005) - 添加Buff已发送');
  }, 1000);
  
  // 测试 4: Buff移除
  setTimeout(() => {
    ws.send(JSON.stringify({ cmd: 2005, userID: 1, buffID: 1001, buffLv: 5, buffType: 1, duration: 0, state: 2 }));
    console.log('📤 [4] BUFF (2005) - 移除Buff已发送');
  }, 1500);
  
  setTimeout(() => {
    console.log('\n=== 测试完成 ===');
    ws.close();
    process.exit(0);
  }, 2500);
});

ws.on('message', (data) => {
  console.log('📥 收到响应:', data.toString().substring(0, 200));
});

ws.on('error', (err) => {
  console.error('❌ 错误:', err.message);
  process.exit(1);
});