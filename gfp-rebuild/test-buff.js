const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:8080');

ws.on('open', () => {
  console.log('=== 开始测试新功能 ===\n');
  
  // 测试 1: 登录
  const login = { cmd: 10001, username: "test", password: "123456" };
  ws.send(JSON.stringify(login));
  console.log('📤 [1] LOGIN (10001)');
  
  // 测试 2: 伤害协议 BRUISE 2003
  setTimeout(() => {
    const bruise = { cmd: 2003, atkerID: 1, userID: 2, decHP: 100, hp: 900, skillID: 1001, type: 1, hitCount: 1 };
    ws.send(JSON.stringify(bruise));
    console.log('📤 [2] BRUISE (2003) - 伤害协议');
  }, 300);
  
  // 测试 3: Buff 添加
  setTimeout(() => {
    const buff = { cmd: 2005, userID: 1, buffID: 1001, buffLv: 5, buffType: 1, duration: 300, state: 1 };
    ws.send(JSON.stringify(buff));
    console.log('📤 [3] BUFF (2005) - 添加Buff');
  }, 600);
  
  // 测试 4: Buff 移除
  setTimeout(() => {
    const buffR = { cmd: 2005, userID: 1, buffID: 1001, buffLv: 5, buffType: 1, duration: 0, state: 2 };
    ws.send(JSON.stringify(buffR));
    console.log('📤 [4] BUFF (2005) - 移除Buff');
  }, 900);
  
  setTimeout(() => {
    console.log('\n=== 测试完成 ===');
    ws.close();
  }, 1200);
});

ws.on('message', (data) => {
  console.log('📥 Server:', data.toString().substring(0, 150));
});

ws.on('close', () => {
  process.exit(0);
});