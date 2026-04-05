// GFP 协议验证脚本 - 一键测试所有功能
// 使用方法: node test-all-protocols.js

import WebSocket from "ws";

const ws = new WebSocket("ws://localhost:8080");

console.log("🚀 开始连接 GFP 服务器...");

function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

ws.on("open", () => {
  console.log("✅ 已连接\n");

  (async () => {
    // 1. 测试 LOGIN (10001)
    console.log("📤 [1] LOGIN (10001)");
    ws.send(JSON.stringify({
      cmd: 10001,
      username: "tester",
      password: "123456",
      session: "test-session-123",
      roleTime: Date.now()
    }));
    
    await delay(500);

    // 2. 测试 SELECT_ROLE (10005)
    console.log("📤 [2] SELECT_ROLE (10005) - 选择角色 1");
    ws.send(JSON.stringify({ cmd: 10005, roleId: 1 }));
    await delay(500);

    // 3. 测试 ENTER_GAME (10006)
    console.log("📤 [3] ENTER_GAME (10006)");
    ws.send(JSON.stringify({ cmd: 10006 }));
    await delay(500);

    // 4. 测试 MOVE
    console.log("📤 [4] MOVE (1001) - 移动到 (100, 200) 地图 1001");
    ws.send(JSON.stringify({
      cmd: 1001,
      mapId: 1001,
      pos: { x: 100, y: 200 },
      speed: 150,
      moveType: 1
    }));
    await delay(300);

    // 5. 测试 STAND
    console.log("📤 [5] STAND (1002) - 站立在 (150, 250)");
    ws.send(JSON.stringify({
      cmd: 1002,
      mapId: 1001,
      pos: { x: 150, y: 250 },
      direction: 1
    }));
    await delay(300);

    // 6. 测试 JUMP
    console.log("📤 [6] JUMP (1003) - 跳跃到 (200, 100)");
    ws.send(JSON.stringify({
      cmd: 1003,
      pos: { x: 200, y: 100 }
    }));
    await delay(300);

    // 7. 测试 PVP_MOVE
    console.log("📤 [7] PVP_MOVE (1004) - PVP移动");
    ws.send(JSON.stringify({
      cmd: 1004,
      mapId: 1001,
      pos: { x: 300, y: 300 },
      speed: 200,
      moveType: 2,
      timestamp: Date.now()
    }));
    await delay(500);

    // 8. 测试 MAP_SWITCH
    console.log("📤 [8] MAP_SWITCH (14005) - 切换到地图 1002 (竹林深处)");
    ws.send(JSON.stringify({ cmd: 14005, targetMapId: 1002 }));
    await delay(1000);

    // 9. 测试 ACTION_SKILL
    console.log("📤 [9] ACTION_SKILL (2004) - 重击技能");
    ws.send(JSON.stringify({
      cmd: 2004,
      skillId: 1002,
      skillLv: 3,
      pos: { x: 400, y: 400 },
      targetId: 1,
      direction: 1
    }));
    await delay(500);

    // 10. 测试 ACTION_BRUISE
    console.log("📤 [10] ACTION_BRUISE (2003) - 受到100点伤害");
    ws.send(JSON.stringify({
      cmd: 2003,
      atkerID: 2, userID: 1,
      decHP: 100, hp: 900,
      skillID: 1001, type: 1,
      hitCount: 1
    }));
    await delay(300);

    // 11. 测试 BUFF_STATE 添加
    console.log("📤 [11] BUFF_STATE (2005) - 添加防御Buff");
    ws.send(JSON.stringify({
      cmd: 2005,
      userID: 1, buffID: 1001,
      buffLv: 5, buffType: 1,
      duration: 300, state: 1
    }));
    await delay(300);

    // 12. 测试 BUFF_STATE 移除
    console.log("📤 [12] BUFF_STATE (2005) - 移除Buff");
    ws.send(JSON.stringify({
      cmd: 2005,
      userID: 1, buffID: 1001,
      buffLv: 5, buffType: 1,
      duration: 0, state: 2
    }));
    await delay(500);

    // 13. 测试 ITEM_PICKUP
    console.log("📤 [13] ITEM_PICKUP (3001) - 拾取物品");
    ws.send(JSON.stringify({
      cmd: 3001,
      items: [
        { itemId: 10001, count: 1 },
        { itemId: 20001, count: 5 }
      ]
    }));

    await delay(500);
    console.log("\n✅ 全部 13 个协议测试完成！");
    console.log("📝 请查看上面服务器返回的响应日志验证功能是否正常\n");

    setTimeout(() => { ws.close(); process.exit(0); }, 3000);
  })();
});

ws.on("message", (data) => {
  try {
    const msg = data.toString();
    if (msg.startsWith("{") || msg.startsWith("[")) {
      console.log(`📥 Server: ${msg.substring(0, 300)}`);
    } else {
      console.log(`📥 ${msg.substring(0, 300)}`);
    }
  } catch {
    console.log(`📥 [原始] ${data.toString().substring(0, 300)}`);
  }
});

ws.on("error", (err) => {
  console.error("❌ 错误:", err.message);
  process.exit(1);
});

ws.on("close", () => {
  console.log("🔌 断开");
  process.exit(0);
});