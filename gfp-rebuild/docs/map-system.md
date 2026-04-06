# 地图切换系统设计文档

## 一、概述

本文档描述了 GFP 重制版中地图切换系统的技术设计，包括协议定义、数据模型、处理流程和广播机制。

## 二、数据模型

### 2.1 地图配置 (`types/map.ts`)

所有静态地图数据集中管理在 `MAP_CONFIG` 中，作为唯一数据源：

```typescript
export interface MapInfo {
  mapId: number;        // 地图唯一ID
  mapName: string;      // 地图名称
  width: number;        // 地图宽度 (像素)
  height: number;       // 地图高度 (像素)
  bgMusic?: string;     // 背景音乐
  isPVP?: boolean;      // 是否为PVP地图
  isDungeon?: boolean;  // 是否为副本地图
  requiredLevel?: number; // 等级限制
  limitTime?: number;   // 副本时间限制 (秒)
}
```

当前配置的5张地图：

| mapId | 名称 | 宽高 | 等级要求 | 特殊 |
|-------|------|------|----------|------|
| 1001 | 新手村 | 2000x1500 | 1 | - |
| 1002 | 竹林深处 | 2500x2000 | 5 | - |
| 1003 | 虎口山谷 | 3000x2500 | 10 | - |
| 1004 | 蛇影洞 | 1800x1200 | 15 | 副本 |
| 1005 | 竞技场 | 1500x1500 | - | PVP |

### 2.2 默认出生点 (`DEFAULT_SPAWN_POINTS`)

每张地图配置了默认出生坐标，玩家切换进入时会传送到该位置（除非请求指定了具体坐标）。

### 2.3 切换请求格式

```typescript
interface MapSwitchRequest {
  targetMapId: number;    // 目标地图ID
  teleportType?: number;  // 0=步行 1=传送 2=过渡动画
  position?: {            // 可选：自定义落点
    x: number;
    y: number;
  };
}
```

### 2.4 切换响应格式

```typescript
interface MapSwitchResponse {
  result: number;  // 0=成功, 1=地图不存在, 2=等级不足, 3=副本需传送, 4=已在该地图
  mapId: number;
  mapName?: string;
  position: { x: number; y: number };
  newMapData?: {
    width: number;
    height: number;
    isPVP: boolean;
    isDungeon: boolean;
    bgMusic: string;
  };
}
```

## 三、协议定义

### 3.1 相关命令列表

| CommandID | 名称 | 方向 | 说明 |
|-----------|------|------|------|
| 14005 | MAP_SWITCH | C→S | 地图切换请求 |
| 14005 | MAP_SWITCH | S→C | 地图切换响应/确认 |
| 14003 | LEAVE_MAP | S→广播 | 玩家离开地图通知 |
| 14001 | USER_LIST | S→C | 当前地图玩家列表 |

### 3.2 通信时序

```
客户端                          服务端
  |                               |
  |------- CMD=14005 ----------->|  { targetMapId, teleportType, position? }
  |                               |
  |  (验证地图/等级/副本限制)        |
  |                               |
  |<------ CMD=14005 -----------|  响应 { result=0, mapId, mapName, position, newMapData }
  |                               |
  |<------ CMD=14003 -----------|  (旧地图广播) { userId, mapId: 旧地图ID }
  |                               |
  |<------ CMD=14001 -----------|  (新地图广播) { userId, nickName, roleType, ... }
  |                               |
  |<------ CMD=14001 -----------|  (玩家列表) { players: [ {userId, nickName, ...} ] }
  |                               |
```

## 四、处理流程

### 4.1 地图切换主流程

```
handleMapSwitch(client, data)
│
├─ 1. 检查 client.player 是否已初始化
│     └─ 未初始化 → return
│
├─ 2. 解析请求参数 (targetMapId, teleportType, position)
│
├─ 3. 验证地图存在 (MAP_CONFIG[targetMapId])
│     └─ 不存在 → result=1
│
├─ 4. 检查等级限制 (mapConfig.requiredLevel)
│     └─ 等级不足 → result=2
│
├─ 5. 检查副本限制 (isDungeon && teleportType=步行)
│     └─ 违规进入 → result=3
│
├─ 6. 确定目标位置
│     ├─ 有指定坐标 → 使用指定坐标
│     └─ 无指定坐标 → 使用 DEFAULT_SPAWN_POINTS 或 fallback (500,500)
│
├─ 7. 检查是否已在该地图
│     └─ 是 → result=4
│
├─ 8. 更新玩家状态
│     ├─ client.player.mapId = targetMapId
│     ├─ client.player.pos = spawnPoint
│     └─ client.player.lastUpdate = Date.now()
│
├─ 9. 发送切换响应 (CMD=14005, result=0)
│
├─ 10. 广播离开旧地图 (CMD=14003) → 旧地图上的其他玩家
│
├─ 11. 广播加入新地图 (CMD=14001) → 新地图上的其他玩家
│
└─ 12. 发送新地图玩家列表 (CMD=14001) → 当前玩家
```

## 五、广播机制

### 5.1 按地图范围广播

广播分为三个层级：

| 方法 | 范围 | 用途 |
|------|------|------|
| `broadcast(data)` | 全服所有玩家 | 全局消息 |
| `broadcastToOthers(excludeId, data)` | 除自己外所有玩家 | 移动/技能等同步 |
| `broadcastToMap(mapId, excludeId, data)` | 仅同地图玩家 | 地图切换通知 |

**地图切换相关广播** 使用 `broadcastToMap`，避免无关地图的玩家收到无效通知。

### 5.2 玩家断线处理

玩家断线时，同样向所在地图的其他玩家广播 `LEAVE_MAP` 通知：

```
handleClientDisconnect(client)
├─ 记录 client.player.mapId (旧地图)
├─ 从 gameState.players 删除
└─ broadcastToMap(oldMapId, player.id, {14003: {userId, mapId}})
```

## 六、架构设计

### 6.1 模块职责

```
index.ts (GFPServer)
├─ WebSocket 连接管理
├─ 玩家状态管理 (gameState.players)
├─ 移动/战斗/拾取等处理器 (内联 + 模块化)
├─ 广播方法 (broadcast / broadcastToOthers / broadcastToMap)
└─ 位置验证 (validatePosition - 使用 MAP_CONFIG 动态边界)

handlers/MapHandler.ts
├─ handleMapSwitch() — 核心切换逻辑
├─ sendPlayersOnMap() — 发送同地图玩家列表
├─ getSpawnPoint() — 计算目标位置
└─ encodePacket() — 构造二进制数据包

types/map.ts
├─ MapInfo / MapSwitchRequest / MapSwitchResponse 等类型定义
├─ MapObject / MapPlayerInfo 等扩展类型
├─ MAP_CONFIG — 5张地图的静态配置 (唯一数据源)
└─ DEFAULT_SPAWN_POINTS — 各地图默认出生点
```

### 6.2 数据流

```
client.app.dll (AS3)
  │  MapProcess_XXXXXX.as (521个地图工厂类)
  │  请求切换: 发送 ByteArray [length][14005][body]
  ↓
GFP Server (TypeScript)
  │  PacketDecoder.decode → JSON payload
  │  handlers/MapHandler.handleMapSwitch()
  ├─ 验证: MAP_CONFIG (types/map.ts)
  ├─ 定位: DEFAULT_SPAWN_POINTS (types/map.ts)
  ├─ 更新: Client.player.mapId / pos (index.ts)
  ├─ 广播: broadcastToMap → PacketEncoder.encode
  └─ 响应: sendTo → {result, mapId, mapName, position, newMapData}
  ↓
client.app.dll (AS3)
  │  收到 CMD=14005 → 触发 Bean listener
  │  加载新地图资源 / 显示过渡动画
  │  收到 CMD=14001 → 显示新地图上的其他玩家
  ↓
```

## 七、设计决策

### 7.1 集中式配置 vs 数据库

当前使用 `types/map.ts` 集中硬编码地图配置，原因：
- 阶段一仅5张地图，配置量小
- 无需修改配置的热重载能力
- 编译期类型安全

**后续扩展**：当地图数量增多且需要热更新时，可将 `MAP_CONFIG` 迁移至外部 JSON/XML 文件，或从服务端数据库加载。

### 7.2 JSON 协议体

`PacketEncoder.encode()` 将 JS 对象序列化为 UTF-8 字节流附加在二进制帧中：

```
[length: 4B LE][commandId: 4B LE][body: JSON UTF-8]
```

这保持了与原 AS3 `ByteArray` 序列化协议的一致性，同时避免了手动定义每个字段的字节偏移。

### 7.3 地图切换不跨地图广播

移动/技能等实时同步广播默认发给所有玩家（跨地图），而切换通知仅使用 `broadcastToMap` 限制在相关地图范围内。这减少了网络带宽，也更符合游戏逻辑——无关地图的玩家不需要收到通知。
