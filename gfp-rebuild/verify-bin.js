/**
 * GFP 协议验证脚本（二进制版本）
 * 正确使用 PacketEncoder 编码数据包
 */

const WebSocket = require('ws');

// 引入项目编解码器（必须先编译）
const { PacketEncoder, CommandID } = require('./client/dist/network/PacketCodec');

const SERVER_URL = 'ws://localhost:8080';

// 颜色输出
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
};

function log(msg, color = colors.reset) {
  console.log(`${color}${msg}${colors.reset}`);
}

function success(msg) {
  log(`✅ ${msg}`, colors.green);
}

function error(msg) {
  log(`❌ ${msg}`, colors.red);
}

function info(msg) {
  log(`ℹ️  ${msg}`, colors.cyan);
}

function section(msg) {
  log(`\n${'='.repeat(50)}`, colors.yellow);
  log(msg, colors.yellow);
  log(`${'='.repeat(50)}`, colors.yellow);
}

async function runTests() {
  section('🔗 Connecting to GFP Server');
  const ws = new WebSocket(SERVER_URL);

  await new Promise((resolve, reject) => {
    ws.on('open', () => {
      success('Connected to server');
      resolve();
    });
    ws.on('error', (err) => reject(err));
    setTimeout(() => reject(new Error('Connection timeout')), 5000);
  });

  // 测试 1: LOGIN 登录
  section('📝 Test 1: LOGIN (10001)');
  const loginPacket = PacketEncoder.encode(CommandID.LOGIN_IN, {
    session: "test_session_123",
    roleTime: Date.now(),
    serverVersion: "1.0",
    clientType: 1,
    isAdult: 1
  });
  ws.send(loginPacket);
  info('Sent LOGIN request (binary)');

  setTimeout(() => info('(No response expected for LOGIN without proper auth)'), 500);

  // 测试 2: MOVE 移动
  section('🚀 Test 2: MOVE (1001)');
  const movePacket = PacketEncoder.encode(CommandID.MOVE, {
    mapId: 1001,
    pos: { x: 500, y: 300 },
    speed: 150,
    moveType: 1
  });
  ws.send(movePacket);
  info('Sent MOVE request');

  setTimeout(() => { }, 500);

  // 测试 3: JUMP 跳跃
  section('🦘 Test 3: JUMP (1003)');
  const jumpPacket = PacketEncoder.encode(CommandID.JUMP, {
    pos: { x: 500, y: 200 }
  });
  ws.send(jumpPacket);
  info('Sent JUMP request');

  setTimeout(() => { }, 500);

  // 测试 4: ACTION_BRUISE 伤害
  section('⚔️  Test 4: ACTION_BRUISE (2003)');
  const bruisePacket = PacketEncoder.encode(CommandID.ACTION_BRUISE, {
    atkerID: 1,
    userID: 2,
    decHP: 100,
    hp: 900,
    skillID: 1001,
    type: 1,
    hitCount: 1
  });
  ws.send(bruisePacket);
  info('Sent ACTION_BRUISE request');

  setTimeout(() => { }, 500);

  // 测试 5: BUFF_STATE Buff状态
  section('✨ Test 5: BUFF_STATE (2005)');
  const buffPacket = PacketEncoder.encode(CommandID.BUFF_STATE, {
    userID: 1,
    buffID: 1001,
    buffLv: 5,
    buffType: 1,
    duration: 300,
    state: 1  // add
  });
  ws.send(buffPacket);
  info('Sent BUFF_STATE (add)');

  setTimeout(() => { }, 500);

  // 测试 6: MAP_SWITCH 地图切换
  section('🗺️  Test 6: MAP_SWITCH (14005)');
  const mapSwitchPacket = PacketEncoder.encode(CommandID.MAP_SWITCH, {
    targetMapId: 1001,
    teleportType: 0,
    position: { x: 500, y: 800 }
  });
  ws.send(mapSwitchPacket);
  info('Sent MAP_SWITCH request');

  // 等待足够时间看响应
  await new Promise(resolve => setTimeout(resolve, 2000));

  // 测试 7: STAND 站立
  section('🧍 Test 7: STAND (1002)');
  const standPacket = PacketEncoder.encode(CommandID.STAND, {
    mapId: 1001,
    pos: { x: 500, y: 300 },
    direction: 1
  });
  ws.send(standPacket);
  info('Sent STAND request');

  await new Promise(resolve => setTimeout(resolve, 2000));

  // 结束
  section('🎯 Test Summary');
  success('All binary protocol tests completed!');
  info('Check the server console for detailed logs.');
  info('If any responses are missing, the server may have rejected the packet.');

  ws.close();
  setTimeout(() => process.exit(0), 1000);
}

// 启动测试
log('🔋 GFP Protocol Verification Script (Binary)', colors.green);
log(`Server: ${SERVER_URL}\n`, colors.blue);

runTests().catch((err) => {
  error(`Test failed: ${err.message}`);
  process.exit(1);
});
