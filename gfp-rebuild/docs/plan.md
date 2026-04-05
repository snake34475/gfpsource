# 功夫派 (GFP) 协议层开发计划 - 阶段完成

## 一、项目概述

| 项目 | 说明 |
|------|------|
| 游戏名称 | 功夫派 (GongFuPai) |
| 开发阶段 | 第一阶段：协议层 |
| 技术栈 | TypeScript + Phaser 3 (客户端) + Node.js (服务器) |
| 通信方式 | WebSocket (桥接调试模式) |

## 二、阶段目标

实现网络通信基础，复原所有消息协议，使客户端能连接模拟服务器。

## 三、开发任务清单

### 3.1 第一周：基础架构搭建

| 任务 | 状态 | 说明 |
|------|------|------|
| 创建项目结构 | ✅ | client + server 目录 |
| 创建 plan.md 文档 | ✅ | 本文档 |
| 配置 package.json | ✅ | npm 依赖配置 |
| 创建 TypeScript 配置 | ✅ | tsconfig.json |

### 3.2 第二周：CommandID 提取与基础协议

| 任务 | 状态 | 说明 |
|------|------|------|
| 提取 CommandID 常量 | ✅ | 从 1257 个源码匹配中提取 |
| 创建 CommandID.ts | ✅ | 枚举定义（100+协议） |
| 创建数据类型定义 | ✅ | battle.ts, move.ts 等 |

### 3.3 第三周：编解码器与网络层

| 任务 | 状态 | 说明 |
|------|------|------|
| 实现 PacketEncoder | ✅ | 客户端数据包编码 |
| 实现 PacketDecoder | ✅ | 客户端数据包解码 |
| 实现 SocketClient | ✅ | WebSocket 连接模块 |

### 3.4 第四周：模拟服务器

| 任务 | 状态 | 说明 |
|------|------|------|
| WebSocket 服务器 | ✅ | 监听 8080 端口 |
| 服务端编解码器 | ✅ | 解码/编码数据包 |
| 协议处理器 | ✅ | 处理 MOVE, STAND 等 |

## 四、协议清单

### 4.1 移动相关

| CommandID | 名称 | 数据结构 |
|-----------|------|----------|
| 1001 | MOVE | mapID, pos(x,y), speed, moveType |
| 1002 | STAND | mapID, pos(x,y), direction |
| 1003 | JUMP | pos(x,y) |
| 1004 | PVP_MOVE | pos, mapID, speed, type, timestamp |
| 1005 | MOUSE_MOVE | pos(x,y) |
| 1006 | OGRE_MOVE | 同 MOVE |
| 1007 | SUMMON_MOVE | 召唤兽移动 |
| 1008 | SUMMON_FOLLOW | 召唤兽跟随 |

### 4.2 战斗相关

| CommandID | 名称 | 数据结构 |
|-----------|------|----------|
| 2001 | FIGHT_START | FightReadyInfo |
| 2002 | FIGHT_END | reason, result, punish |
| 2003 | ACTION_BRUISE | decHP, hp, atkerID, userID, crit, type... |
| 2004 | ACTION_SKILL | skillID, skillLv, pos, targetID |
| 2005 | BUFF_ADD | userID, keyID, buffID, add |
| 2006 | BUFF_REMOVE | userID, keyID |

### 4.3 物品相关

| CommandID | 名称 | 数据结构 |
|-----------|------|----------|
| 3001 | ITEM_PICKUP | count, items[] |
| 3002 | ITEM_BUY | itemID, count |
| 3003 | ITEM_USE | itemID |
| 3004 | ITEM_DROP | itemID, count |

### 4.4 社交相关

| CommandID | 名称 | 数据结构 |
|-----------|------|----------|
| 4001 | TRADE_REQUEST | targetUserID |
| 4002 | TRADE_ACCEPT | result |
| 4003 | TRADE_CONFIRM | 确认交易 |
| 4004 | MAIL_SEND | mailInfo |
| 4005 | MAIL_RECEIVE | mailList |

## 五、数据包格式

### 5.1 通用格式

```
[包头 4byte] [命令ID 4byte] [数据体 ...]
```

- 包头：数据包总长度 (uint32)
- 命令ID：CommandID (uint32)
- 数据体：各协议自定义结构

### 5.2 MOVE 协议示例

```
位置: 0-3     -> mapID (uint32)
位置: 4-7     -> pos.x (uint32)
位置: 8-11    -> pos.y (uint32)
位置: 12      -> speed (uint8)
位置: 13      -> moveType (uint8)
```

### 5.3 ACTION_BRUISE 协议示例

```
位置: 0-3     -> decHP (int32)
位置: 4-7     -> hp (int32)
位置: 8-11    -> atkerID (uint32)
位置: 12-15   -> userID (uint32)
位置: 16      -> crit (bool)
位置: 17      -> critMultiple (uint8)
位置: 18      -> decType (uint8)
位置: 19      -> type (uint8)
位置: 20      -> hitCount (uint8)
位置: 21      -> breakFlag (bool)
位置: 22-25   -> skillID (uint32)
位置: 26      -> skillLv (uint8)
位置: 30-33   -> runDuration (float)
位置: 34-37   -> stiffDuration (float)
位置: 38-41   -> pos.x (float)
位置: 42-45   -> pos.y (float)
```

## 六、文件结构

```
gfp-rebuild/
├── client/                         # 客户端
│   ├── src/
│   │   ├── network/
│   │   │   ├── SocketClient.ts    # WebSocket连接
│   │   │   ├── CommandID.ts       # 命令常量 (100+ 协议)
│   │   │   ├── PacketEncoder.ts   # 数据包编码
│   │   │   └── PacketDecoder.ts   # 数据包解码
│   │   ├── types/
│   │   │   ├── battle.ts          # 战斗类型定义
│   │   │   └── index.ts
│   │   └── index.ts
│   ├── package.json
│   ├── tsconfig.json
│   └── dist/                      # 编译输出
│
├── server/                         # 模拟服务器
│   ├── src/
│   │   ├── index.ts               # 入口 + WebSocket服务
│   │   ├── protocol/
│   │   │   └── PacketCodec.ts    # 服务端编解码器
│   │   └── types/
│   │       └── index.ts
│   ├── package.json
│   ├── tsconfig.json
│   └── dist/                      # 编译输出
│
└── docs/
    └── plan.md                    # 开发计划文档
```

## 七、技术实现

### 7.1 客户端 (TypeScript)

| 模块 | 文件 | 功能 |
|------|------|------|
| 网络层 | SocketClient.ts | WebSocket 连接、重连、心跳 |
| 编解码 | PacketEncoder.ts | 数据包编码（小端序） |
| 编解码 | PacketDecoder.ts | 数据包解码 |
| 常量 | CommandID.ts | 100+ 协议命令常量 |
| 类型 | battle.ts | BruiseInfo, MoveInfo 等 |

### 7.2 服务端 (Node.js)

| 模块 | 文件 | 功能 |
|------|------|------|
| 服务器 | index.ts | WebSocket 服务器，端口 8080 |
| 编解码 | protocol/PacketCodec.ts | 服务端编解码实现 |
| 处理器 | handlers/* | MOVE, STAND, SKILL 等处理 |

### 7.3 数据包格式

```
[包头 4byte] [命令ID 4byte] [数据体 ...]
```
- 包头：数据包总长度 (uint32, 小端序)
- 命令ID：CommandID (uint32, 小端序)
- 数据体：各协议自定义结构（小端序）

## 八、启动方式

### 服务端
```bash
cd gfp-rebuild/server
npm run dev
# 输出: [GFP Server] WebSocket server started on port 8080
```

### 客户端连接
```typescript
import { socketClient } from './network/SocketClient';
import { CommandID } from './network/CommandID';

await socketClient.connect();
socketClient.move(1001, 500, 300, 150, 1);
```

## 九、验收标准

1. ✅ 客户端能通过 WebSocket 连接到服务器
2. ✅ 客户端发送 MOVE/STAND/JUMP 命令，服务器能正确解析
3. ✅ 服务器能返回正确的响应数据包
4. ✅ 客户端能正确解析服务器返回的数据

## 十、如何运行

### 前置要求
- Node.js (v16+)
- npm

### 步骤一：启动服务端

```bash
# 进入项目目录
cd gfp-rebuild

# 进入服务端目录
cd server

# 安装依赖
npm install

# 编译并启动
npm run dev
```

服务器启动后显示:
```
[GFP Server] WebSocket server started on port 8080
[GFP Server] Connect via ws://localhost:8080
```

### 步骤二：测试客户端通信

**方式1：使用内置测试脚本**

```bash
# 在项目根目录安装依赖
cd gfp-rebuild
npm install

# 运行测试客户端
npm run test-client
# 或
node test-client.js
```

测试脚本会:
1. 连接到服务器
2. 发送 MOVE 命令 (坐标 500, 300)
2秒后发送 STAND 命令
4秒后发送 JUMP 命令
7秒后自动退出

服务器会显示接收到的消息:
```
[GFP Server] Received: CMD=1001 {"mapId":1001,"pos":{"x":500,"y":300},"speed":150,"moveType":1}
[GFP Server] Player 1 moved to (500, 300)
```

**方式2：自定义测试**

创建 `my-test.js`:

```javascript
const WebSocket = require('ws');
const ws = new WebSocket('ws://localhost:8080');

ws.on('open', () => {
  console.log('Connected!');
  // 发送 MOVE
  const data = Buffer.alloc(20);
  data.writeUInt32LE(20, 0);  // length
  data.writeUInt32LE(1001, 4); // commandId
  data.writeUInt32LE(1001, 8); // mapId
  data.writeUInt32LE(600, 12); // x
  data.writeUInt32LE(400, 16); // y
  ws.send(data);
});

ws.on('message', (data) => {
  console.log('Received:', data);
});
```

运行:
```bash
node my-test.js
```

### 步骤三：在实际项目中使用客户端

在浏览器环境或 Node.js 环境中导入客户端库:

```typescript
import { socketClient, CommandID } from './client/src/index';

async function main() {
  await socketClient.connect('ws://localhost:8080');
  console.log('Connected to GFP Server');
  
  // 监听服务器消息
  socketClient.addHandler(CommandID.MOVE, (data) => {
    console.log('Player moved:', data);
  });
  
  // 发送移动
  socketClient.move(1001, 500, 300, 150, 1);
}
```

---

## 十一、注意事项

1. **不使用加密**：WebSocket 桥接模式使用明文传输，简化调试
2. **字节序**：使用小端序 (little-endian)，与 Flash/AS3 一致
3. **调试端口**：默认使用 8080，便于调试
4. **原CommandID**：从源码 1257 个 grep 匹配中提取，共 100+ 协议

## 十一、下一步计划

第二阶段：登录+地图系统

- 登录界面 + 验证逻辑
- 选服/选角界面
- 地图资源加载
- 玩家渲染 + 移动同步

---

**文档版本**: 1.1
**创建日期**: 2026-04-05
**更新日志**:
- 2026-04-05: 初始版本
- 2026-04-05: 更新完成状态，添加技术实现文档