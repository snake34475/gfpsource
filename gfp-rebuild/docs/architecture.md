# 功夫派 (GFP) 协议层架构设计文档

## 文档概述

本文档详细记录功夫派复刻项目第一阶段（协议层）的完整架构设计、开发思路和实现细节。

---

## 一、架构设计思路

### 1.1 为什么选择 TypeScript + Node.js

| 考量因素 | 选择 | 理由 |
|---------|------|------|
| 语言 | TypeScript | 与 AS3 语法高度相似，转换成本最低 |
| 服务器 | Node.js | 快速开发，WebSocket 原生支持 |
| 通信 | WebSocket | 桥接调试模式，便于开发测试 |
| 生态 | npm | 丰富的基础库支持 |

**核心原则**：先实现功能，再考虑优化。协议层的目标是建立通信基础，不需要过度设计。

### 1.2 不使用原有加密协议的原因

1. **调试复杂度**：MEncrypt 加密需要逆向分析，增加开发难度
2. **目标差异**：从零重建客户端，不需要兼容旧客户端
3. **WebSocket 特性**：本身是明文传输，简化开发流程
4. **可扩展性**：后期如有需要可添加加密层

---

## 二、整体架构

```
┌─────────────────────────────────────────────────────────────────┐
│                         客户端 (TypeScript)                     │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │  Socket     │  │  Packet     │  │  Packet     │            │
│  │  Client    │←→│  Encoder    │←→│  Decoder    │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│         ↓                   ↓                   ↓               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              CommandID (命令常量层)                      │   │
│  │   1001:MOVE  1002:STAND  2003:ACTION_BRUISE  ...        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                              ↓                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              Types (数据类型层)                           │   │
│  │   BruiseInfo  MoveInfo  SkillInfo  BuffInfo             │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              ↕ WebSocket (ws://localhost:8080)
┌─────────────────────────────────────────────────────────────────┐
│                         服务器 (Node.js)                         │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │  WebSocket  │  │  Packet     │  │  Packet     │            │
│  │  Server    │→ │  Decoder    │→ │  Encoder    │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│         ↓                   ↓                   ↓               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              Handlers (协议处理器)                       │   │
│  │   handleMove  handleStand  handleSkill  handleBruise    │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 三、核心模块设计

### 3.1 CommandID 常量层

#### 设计思路
- 从源码中提取所有使用的 CommandID
- 使用 TypeScript enum 实现类型安全
- 按功能分类：移动、战斗、物品、社交等

#### 实现细节
```typescript
export enum CommandID {
  // 移动相关 (1001-1010)
  MOVE = 1001,
  STAND = 1002,
  JUMP = 1003,
  PVP_MOVE = 1004,
  OGRE_MOVE = 1006,
  SUMMON_MOVE = 1007,
  SUMMON_FOLLOW = 1008,

  // 战斗相关 (2001-2050)
  ACTION_BRUISE = 2003,
  ACTION_SKILL = 2004,
  BUFF_STATE = 2005,
  FIGHT_START = 2007,
  FIGHT_END = 2008,
  // ... 共 100+ 协议
}
```

#### 提取方法
- 使用 grep 搜索 `CommandID\.[A-Z_]+` 获取所有引用
- 从 1257 个源码匹配中提取不重复的常量
- 按源码中实际使用的顺序整理

### 3.2 数据包格式设计

#### 通用格式
```
[包头 4byte] [命令ID 4byte] [数据体 N byte]
```

| 字段 | 长度 | 字节序 | 说明 |
|------|------|--------|------|
| length | 4 | 小端 | 数据包总长度 |
| commandId | 4 | 小端 | 命令ID |
| body | N | 小端 | 数据体（各协议不同） |

#### 为什么选择小端序
- Flash/AS3 的 ByteArray 默认使用小端序
- 与原客户端保持一致，减少转换错误

### 3.3 PacketEncoder 设计

#### 核心思路
- 将不同类型的数据（number/string/boolean/array）转换为字节流
- 根据数值范围选择最小字节长度（varint思想）
- 支持嵌套对象和数组

#### 类型处理策略
```typescript
private static encodeValue(value: any): Uint8Array {
  if (typeof value === "number") {
    if (Number.isInteger(value)) {
      // 正数：根据范围选择 1/2/4 byte
      // 负数：固定 4 byte (int32)
    } else {
      // 浮点数：4 byte (float32)
    }
  } else if (typeof value === "string") {
    // UTF8 编码，2 byte 长度前缀
  } else if (typeof value === "boolean") {
    // 1 byte: 0 或 1
  } else if (Array.isArray(value)) {
    // 4 byte 长度前缀 + 递归编码
  }
}
```

### 3.4 PacketDecoder 设计

#### 核心思路
- 根据 commandId 区分不同协议的数据结构
- 每个协议有独立的解析逻辑
- 支持部分解析（未知协议返回原始字节）

#### 协议解析示例 (MOVE)
```typescript
case 1001: // MOVE
  data.mapId = view.getUint32(offset, true); offset += 4;
  data.pos = {
    x: view.getUint32(offset, true),
    y: view.getUint32(offset + 4, true),
  };
  offset += 8;
  data.speed = view.getUint8(offset); offset += 1;
  data.moveType = view.getUint8(offset);
  break;
```

#### 协议解析示例 (ACTION_BRUISE)
```typescript
case 2003: // ACTION_BRUISE
  data.decHP = view.getInt32(offset, true); offset += 4;
  data.hp = view.getInt32(offset, true); offset += 4;
  data.atkerID = view.getUint32(offset, true); offset += 4;
  data.userID = view.getUint32(offset, true); offset += 4;
  data.crit = view.getUint8(offset) === 1; offset += 1;
  data.critMultiple = view.getUint8(offset); offset += 1;
  // ... 更多字段
```

### 3.5 SocketClient 设计

#### 核心功能
1. **连接管理**：WebSocket 连接、重连机制
2. **消息发送**：编码并发送数据包
3. **消息接收**：解码并分发到处理器
4. **事件系统**：继承 EventEmitter，支持自定义事件

#### 重连机制
```typescript
private handleReconnect(): void {
  if (this.reconnectAttempts >= this.maxReconnectAttempts) {
    return; // 最多重连 5 次
  }
  this.reconnectAttempts++;
  setTimeout(() => {
    this.connect().catch(...);
  }, this.reconnectInterval); // 3秒间隔
}
```

#### 消息分发
```typescript
// 注册处理器
socketClient.addHandler(CommandID.MOVE, (data) => {
  console.log('收到移动:', data);
});

// 内部分发
const handlers = this.handlers.get(commandId);
if (handlers) {
  for (const handler of handlers) {
    handler(payload, this.userId);
  }
}
```

---

## 四、服务端架构

### 4.1 WebSocket 服务器

```typescript
class GFPServer {
  private wss: WebSocketServer;
  private clients: Map<WebSocket, Client> = new Map();
  private handlers: Map<number, Handler> = new Map();

  start(port: number = 8080): void {
    this.wss = new WebSocketServer({ port });
    this.wss.on("connection", (ws) => {
      // 处理连接
    });
    this.registerHandlers();
  }
}
```

### 4.2 协议处理器模式

```typescript
private registerHandlers(): void {
  this.handlers.set(1001, this.handleMove.bind(this));   // MOVE
  this.handlers.set(1002, this.handleStand.bind(this)); // STAND
  this.handlers.set(1003, this.handleJump.bind(this));  // JUMP
  this.handlers.set(2004, this.handleSkill.bind(this)); // SKILL
}

private handleMove(client: Client, data: any): void {
  console.log("[GFP Server] MOVE:", data);
  // 处理移动逻辑
  // 返回响应
  this.broadcast(response);
}
```

---

## 五、数据结构定义

### 5.1 战斗相关

```typescript
export interface BruiseInfo {
  decHP: number;        // 伤害值
  hp: number;           // 受击后剩余HP
  atkerID: number;      // 攻击者ID
  userID: number;       // 受击者ID
  crit: boolean;        // 是否暴击
  critMultiple: number; // 暴击倍率
  decType: number;      // 伤害类型: 0=扣血, 1=吸收
  type: number;         // 受击动作类型: 0-8
  hitCount: number;    // 连击数
  breakFlag: boolean;  // 是否打断
  skillID: number;     // 技能ID
  skillLv: number;     // 技能等级
  runDuration: number; // 受击动作持续时间
  stiffDuration: number; // 僵直持续时间
  pos: Position;        // 受击位移目标位置
}
```

### 5.2 移动相关

```typescript
export interface MoveInfo {
  userId: number;
  mapId: number;
  pos: Position;
  speed: number;
  moveType: number;
}

export interface StandInfo {
  userId: number;
  mapId: number;
  pos: Position;
  direction: number;
}

export interface JumpInfo {
  userId: number;
  pos: Position;
}
```

---

## 六、开发流程回顾

### 第一步：源码分析
1. 读取 CmdListener 文件，理解协议处理逻辑
2. 从 `addCmdListener` 提取 CommandID 引用
3. 分析 ByteArray 读取顺序，确定数据结构

### 第二步：项目搭建
1. 创建 client/server 目录结构
2. 配置 package.json 和 tsconfig.json
3. 安装依赖 (ws, @types/ws, typescript)

### 第三步：核心实现
1. CommandID.ts - 100+ 协议常量
2. PacketEncoder.ts - 数据包编码
3. PacketDecoder.ts - 数据包解码
4. SocketClient.ts - WebSocket 客户端

### 第四步：服务端实现
1. WebSocket 服务器 (端口 8080)
2. 服务端编解码器
3. 协议处理器 (MOVE/STAND/JUMP)

### 第五步：测试验证
1. 服务端编译通过 ✅
2. 客户端编译通过 ✅
3. 服务器可启动监听 ✅

---

## 七、文件清单

### 客户端 (client/)

| 文件 | 行数 | 功能 |
|------|------|------|
| network/CommandID.ts | ~200 | 100+ 协议常量 |
| network/PacketEncoder.ts | ~135 | 数据包编码 |
| network/PacketDecoder.ts | ~170 | 数据包解码 |
| network/SocketClient.ts | ~190 | WebSocket 客户端 |
| types/battle.ts | ~70 | 数据类型定义 |
| index.ts | ~10 | 导出入口 |

### 服务端 (server/)

| 文件 | 行数 | 功能 |
|------|------|------|
| index.ts | ~150 | WebSocket 服务器 |
| protocol/PacketCodec.ts | ~200 | 服务端编解码 |

---

## 八、后续扩展

### 8.1 第二阶段：登录+地图系统
- 登录协议 (用户名/密码验证)
- 选角协议 (角色列表)
- 地图切换协议
- 玩家信息同步

### 8.2 第三阶段：战斗系统
- 技能释放协议
- 伤害计算协议
- Buff 状态同步
- 战斗结算

### 8.3 可选优化
- 添加加密层 (AES/RSA)
- TCP 原生连接 (替代 WebSocket)
- 性能优化 (对象池/缓存)

---

## 九、总结

本协议层实现的核心价值：

1. **建立通信基础**：客户端与服务器可以双向通信
2. **定义协议标准**：100+ CommandID 常量规范了协议体系
3. **可扩展架构**：支持快速添加新协议处理器
4. **调试友好**：WebSocket 明文传输，便于抓包分析

下一步可以基于此协议层，依次实现登录、地图、战斗等核心功能。

---

**文档版本**: 1.0
**创建日期**: 2026-04-05
**作者**: AI Assistant
**更新日志**:
- 2026-04-05: 初始版本，包含完整架构设计和开发思路