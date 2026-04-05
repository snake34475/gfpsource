/**
 * GFP 协议验证脚本
 * 一键测试所有已实现的协议功能
 */

const WebSocket = require('ws');

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

// 等待消息
function waitForMessage(ws, timeout = 2000) {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      reject(new Error('Timeout waiting for response'));
    }, timeout);

    const onMessage = (data) => {
      clearTimeout(timer);
      ws.removeListener('message', onMessage);
      resolve(JSON.parse(data.toString()));
    };
    ws.on('message', onMessage);
  });
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
  const loginData = {
    cmd: 10001,
    username: "test_user",
    password: "123456"
  };
  ws.send(JSON.stringify(loginData));
  info('Sent LOGIN request');

  try {
    const response = await waitForMessage(ws);
    success('LOGIN response received');
    console.log('Response:', JSON.stringify(response, null, 2));
  } catch (e) {
    error('No response for LOGIN (may be normal if no handler)');
  }

  // 测试 2: MOVE 移动
  section('🚀 Test 2: MOVE (1001)');
  const moveData = {
    cmd: 1001,
    mapId: 1001,
    pos: { x: 500, y: 300 },
    speed: 150,
    moveType: 1
  };
  ws.send(JSON.stringify(moveData));
  info('Sent MOVE request');

  try {
    const response = await waitForMessage(ws);
    success('MOVE response received');
  } catch (e) {
    error('No response for MOVE');
  }

  // 测试 3: JUMP 跳跃
  section('🦘 Test 3: JUMP (1003)');
  const jumpData = {
    cmd: 1003,
    pos: { x: 500, y: 200 }
  };
  ws.send(JSON.stringify(jumpData));
  info('Sent JUMP request');

  try {
    const response = await waitForMessage(ws);
    success('JUMP response received');
  } catch (e) {
    error('No response for JUMP');
  }

  // 测试 4: ACTION_BRUISE 伤害
  section('⚔️  Test 4: ACTION_BRUISE (2003)');
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
  info('Sent ACTION_BRUISE request');

  try {
    const response = await waitForMessage(ws);
    success('ACTION_BRUISE response received');
  } catch (e) {
    error('No response for ACTION_BRUISE');
  }

  // 测试 5: BUFF_STATE Buff状态
  section('✨ Test 5: BUFF_STATE (2005)');
  const buffData = {
    cmd: 2005,
    userID: 1,
    buffID: 1001,
    buffLv: 5,
    buffType: 1,
    duration: 300,
    state: 1  // add
  };
  ws.send(JSON.stringify(buffData));
  info('Sent BUFF_STATE (add)');

  try {
    const response = await waitForMessage(ws);
    success('BUFF_STATE response received');
  } catch (e) {
    error('No response for BUFF_STATE');
  }

  // 测试 6: MAP_SWITCH 地图切换
  section('🗺️  Test 6: MAP_SWITCH (14005)');
  const mapSwitchData = {
    cmd: 14005,
    targetMapId: 1001,
    teleportType: 0,
    position: { x: 500, y: 800 }
  };
  ws.send(JSON.stringify(mapSwitchData));
  info('Sent MAP_SWITCH request');

  try {
    const response = await waitForMessage(ws, 3000);
    success('MAP_SWITCH response received');
    console.log('Response:', JSON.stringify(response, null, 2));
  } catch (e) {
    error('No response for MAP_SWITCH');
  }

  // 测试 7: STAND 站立
  section('🧍 Test 7: STAND (1002)');
  const standData = {
    cmd: 1002,
    mapId: 1001,
    pos: { x: 500, y: 300 },
    direction: 1
  };
  ws.send(JSON.stringify(standData));
  info('Sent STAND request');

  try {
    const response = await waitForMessage(ws);
    success('STAND response received');
  } catch (e) {
    error('No response for STAND');
  }

  // 结束
  section('🎯 Test Summary');
  success('All tests completed!');
  info('Check the server console for detailed logs.');
  info('If any protocols did not respond, check server handler registration.');

  ws.close();
  process.exit(0);
}

// 启动测试
log('🔋 GFP Protocol Verification Script', colors.green);
log(`Server: ${SERVER_URL}\n`, colors.blue);

runTests().catch((err) => {
  error(`Test failed: ${err.message}`);
  process.exit(1);
});
