# GFP 验证指南

> 创建日期：2026-04-05  
> 目标：教你一步步验证所有开发的功能

---

## 📁 前置准备

### 项目路径

```
D:\buscode\gfpsource\gfp-rebuild\
├── server/          # 服务端
│   ├── dist/        # 编译输出
│   └── src/         # 源代码
├── client/          # 客户端
├── docs/            # 文档
├── verify.js        # 一键验证脚本
└── package.json
```

---

## 方法一：一键验证脚本（推荐）

### 步骤 1：启动服务器

**打开 PowerShell**，然后粘：

```powershell
cd D:\buscode\gfpsource\gfp-rebuild\server
node dist/index.js
```

看到如下输出说明成功：

```
[GFP Server] Started on ws://localhost:8080
```

⚠️ **注意：** 这个终端窗口不要关！服务器在运行。

### 步骤 2：打开**另一个** PowerShell 窗口

```powershell
cd D:\buscode\gfpsource\gfp-rebuild
node verify.js
```

### 预期输出

```bash
🔋 GFP Protocol Verification Script

==================================================
🔗 Connecting to GFP Server
==================================================
✅ Connected to server

==================================================
📝 Test 1: LOGIN (10001)
==================================================
📤 Sent LOGIN request
✅ LOGIN response received

==================================================
📝 Test 2: MOVE (1001)
==================================================
✅ MOVE response received

==================================================
📝 Test 3: JUMP (1003)
==================================================
✅ JUMP response received

==================================================
⚔️  Test 4: ACTION_BRUISE (2003)
==================================================
✅ ACTION_BRUISE response received

==================================================
✨ Test 5: BUFF_STATE (2005)
==================================================
✅ BUFF_STATE response received

==================================================
🗺️  Test 6: MAP_SWITCH (14005)
==================================================
✅ MAP_SWITCH response received

🎯 Test Summary
✅ All tests completed!
```

---

## 方法二：网页验证

### 步骤 1：先启动服务器（同上）

```powershell
cd D:\buscode\gfpsource\gfp-rebuild\server
node dist/index.js
```

### 步骤 2：打开文件

用浏览器打开：

```
D:\buscode\gfpsource\gfp-rebuild\client\verify.html
```

### 步骤 3：点按钮测试

页面有这些按钮：

| 按钮 | 功能 |
|------|------|
| 连接 | 连接服务器 |
| 登录 | 发送 LOGIN 请求 |
| 移动 | 发送 MOVE 请求 |
| 跳跃 | 发送 JUMP 请求 |
| 伤害 | 发 ACTION_BRUISE |
| Buff | 发送 BUFF_STATE 请求 |
| 地图切换 | 发送 MAP_请求 |
| 断开 | 断开连接 |

---

## 方法三：手动用 Node 验证（极客玩法）

### 用 Node 验证特定协议

```powershell
cd D:\buscode\gfpsource\gfp-rebuild

# 创建测试文件
node -e "
const WebSocket = require('ws');
const ws = new WebSocket('ws://localhost:8080');

ws.on('open', function() {
  console.log('✅ Connected!');

  // 测试 MOVE
  ws.send(JSON.stringify({
    cmd: 1001,
    mapId: 1001,
    x: 500, y: 300,
    speed: 150,
    moveType: 1
  }));
  console.log('📤 Sent MOVE');
});

ws.on('message', function(data) {
  console.log('📥 Response:', data.toString());
});

ws.on('close', function() {
  console.log('Disconnected');
});
"
```

---

## 方法四：Python 验证（如果你更熟 Py）

```powershell
python -c "
import asyncio
import websockets
import json

async def test():
    async with websockets.connect('ws://localhost:8080') as ws:
        print('✅ Connected to GFP Server')

        # 测试 LOGIN
        await ws.send(json.dumps({'cmd': 10001, 'username': 'test', 'password': '123'}))
        resp = await asyncio.wait_for(ws.recv(), timeout=2)
        print(f'📥 LOGIN 响应: {resp}')

        # 测试 MOVE
        await ws.send(json.dumps({
            'cmd': 1001,
            'mapId': 1001,
            'x': 500, 'y': 300,
            'speed': 150,
            'moveType': 1
        }))
        resp = await asyncio.wait_for(ws.recv(), timeout=2)
        print(f'📥 MOVE 响应: {resp}')

        print('✅ Tests passed!')

asyncio.run(test())
"
```

---

## 已实现协议清单

| 协议 | CommandID | 功能 | 验证方法 |
|------|-----------|------|----------|
| LOGIN | 10001 | 登录 | verify.js 测试 1 |
| MOVE | 1001 | 移动 | verify.js 测试 2 |
| STAND | 1002 | 站立 | verify.js 测试 7 |
| JUMP | 1003 | 跳跃 | verify.js 测试 3 |
| ACTION_SKILL | 2004 | 技能 | verify.js 测试 4 |
| ACTION_BRUISE | 2003 | 伤害 | verify.js 测试 4 |
| BUFF_STATE | 2005 | Buff | verify.js 测试 5 |
| MAP_SWITCH | 14005 | 地图切换 | verify.js 测试 6 |

---

## 常见问题

### Q: 验证脚本报 `ECONNREFUSED`？

**原因：** 服务器没启动

**解决：** 确保你先跑了 `node dist/index.js` 在 8080 端口

### Q: 端口被占用怎么办？

**方法：** 修改端口

1. 编辑 `D:\buscode\gfpsource\gfp-rebuild\server\src\index.ts`
2. 找最后一行 `server.start(8080);` 改成 `server.start(9090);`
3. 重新编译：`npm run build`
4. 重新启动

---

*文档版本: 1.0*
*最后更新: 2026-04-05*
