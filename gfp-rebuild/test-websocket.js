const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:8080');

// 登录
const loginData = {
  cmd: 10001,
  username: "test",
  password: "123456"
};

// 发送消息函数
function sendPacket(cmd, data) {
  const packet = Buffer.alloc(4 + 4 + JSON.stringify(data).length);
  packet.writeUInt32LE(cmd, 0);
  packet.writeUInt32LE(0, 4); // length placeholder
  packet.write(JSON.stringify(data), 8);
  return packet;
}

ws.on('open', () => {
  console.log('✅ Connected to GFP Server');
  
  // 测试 1: 登录
  const loginPacket = JSON.stringify(loginData);
  const loginBuf = Buffer.alloc(4 + loginPacket.length);
  loginBuf.writeUInt32LE(10001, 0);
  loginBuf.write(loginPacket, 4);
  ws.send(loginBuf);
  console.log('📤 Sent LOGIN (10001)');
  
  // 测试 2: 伤害协议 (BRUISE 2003)
  setTimeout(() => {
    const bruiseData = {
      cmd: 2003,
      atkerID: 1,
      userID: 2,
      decHP: 100,
      hp: 900,
      skillID: 1001,
      type: 1,
      hitCount: 1
    };
    ws.send(JSON.stringify(bruiseData));
    console.log('📤 Sent ACTION_BRUISE (2003) - 伤害测试');
  }, 1000);
  
  // 测试 3: Buff 状态协议 (BUFF_STATE 2005)
  setTimeout(() => {
    const buffData = {
      cmd: 2005,
      userID: 1,
      buffID: 1001,
      buffLv: 5,
      buffType: 1,
      duration: 300,
      state: 1  // 1=add, 2=remove, 3=update
    };
    ws.send(JSON.stringify(buffData));
    console.log('📤 Sent BUFF_STATE (2005) - Buff测试');
  }, 2000);
  
  // 测试 4: 移除 Buff
  setTimeout(() => {
    const buffRemoveData = {
      cmd: 2005,
      userID: 1,
      buffID: 1001,
      buffLv: 5,
      buffType: 1,
      duration: 0,
      state: 2  // remove
    };
    ws.send(JSON.stringify(buffRemoveData));
    console.log('📤 Sent BUFF_STATE (2005) - 移除Buff');
  }, 3000);
  
  setTimeout(() => {
    ws.close();
    console.log('🔌 Closed connection');
    process.exit(0);
  }, 4000);
});

ws.on('message', (data) => {
  console.log('📥 Received:', data.toString());
});

ws.on('error', (err) => {
  console.error('❌ Error:', err.message);
});