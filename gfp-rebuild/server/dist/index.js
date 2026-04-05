"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.server = void 0;
const ws_1 = __importStar(require("ws"));
const PacketCodec_1 = require("./protocol/PacketCodec");
class GFPServer {
    constructor() {
        this.wss = null;
        this.clients = new Map();
        this.handlers = new Map();
        this.gameState = {
            players: new Map(),
            nextPlayerId: 1,
        };
    }
    start(port = 8080) {
        this.wss = new ws_1.WebSocketServer({ port });
        console.log(`[GFP Server] WebSocket server started on port ${port}`);
        console.log(`[GFP Server] Connect via ws://localhost:${port}`);
        this.wss.on("connection", (ws) => {
            console.log("[GFP Server] New client connected");
            const clientId = this.gameState.nextPlayerId++;
            const client = {
                ws,
                userId: clientId,
                actorId: 0,
                player: undefined
            };
            this.clients.set(ws, client);
            ws.on("message", (data) => {
                this.handleMessage(client, data);
            });
            ws.on("close", () => {
                this.handleClientDisconnect(client);
                console.log(`[GFP Server] Client ${client.userId} disconnected`);
                this.clients.delete(ws);
            });
            ws.on("error", (error) => {
                console.error("[GFP Server] Client error:", error.message);
            });
        });
        this.wss.on("error", (error) => {
            console.error("[GFP Server] Server error:", error);
        });
        this.registerHandlers();
        this.startHeartbeat();
    }
    startHeartbeat() {
        setInterval(() => {
            const now = Date.now();
            for (const [ws, client] of this.clients) {
                if (client.player && ws.readyState === ws_1.default.OPEN) {
                    if (now - client.player.lastUpdate > 60000) {
                        console.log(`[GFP Server] Player ${client.player.id} heartbeat timeout`);
                    }
                }
            }
        }, 30000);
    }
    handleClientDisconnect(client) {
        if (client.player) {
            this.gameState.players.delete(client.player.id);
            console.log(`[GFP Server] Player ${client.player.id} removed from game`);
            this.broadcastPlayerLeave(client.player.id);
        }
    }
    handleMessage(client, data) {
        try {
            const packet = PacketCodec_1.PacketDecoder.decode(data);
            const { header, data: payload } = packet;
            const commandId = header.commandId;
            console.log(`[GFP Server] Received: CMD=${commandId}`, JSON.stringify(payload));
            const handler = this.handlers.get(commandId);
            if (handler) {
                handler(client, payload);
            }
            else {
                console.log(`[GFP Server] No handler for command ${commandId}`);
                switch (commandId) {
                    case 1001:
                    case 1002:
                    case 1003:
                    case 2004:
                    case 3001:
                        this.sendError(client, commandId, "Handler not implemented");
                        break;
                }
            }
        }
        catch (error) {
            console.error("[GFP Server] Failed to handle message:", error);
        }
    }
    registerHandlers() {
        this.handlers.set(1001, this.handleMove.bind(this));
        this.handlers.set(1002, this.handleStand.bind(this));
        this.handlers.set(1003, this.handleJump.bind(this));
        this.handlers.set(1004, this.handlePvpMove.bind(this));
        this.handlers.set(2004, this.handleSkill.bind(this));
        this.handlers.set(3001, this.handleItemPickup.bind(this));
        this.handlers.set(2003, this.handleBruise.bind(this));
        this.handlers.set(2005, this.handleBuffState.bind(this));
        this.handlers.set(14005, this.handleMapSwitch.bind(this));
    }
    handleMove(client, data) {
        console.log("[GFP Server] MOVE:", data);
        const mapId = data.mapId || 0;
        const x = data.pos?.x || 0;
        const y = data.pos?.y || 0;
        const speed = data.speed || 150;
        const moveType = data.moveType || 1;
        if (!this.validatePosition(mapId, x, y)) {
            console.log("[GFP Server] Invalid position:", { mapId, x, y });
            return;
        }
        if (!client.player) {
            client.player = this.createPlayer(client.userId);
        }
        client.player.mapId = mapId;
        client.player.pos = { x, y };
        client.player.speed = speed;
        client.player.moveType = moveType;
        client.player.lastUpdate = Date.now();
        console.log(`[GFP Server] Player ${client.player.id} moved to (${x}, ${y})`);
        this.broadcastPlayerMove(client.player);
    }
    handleStand(client, data) {
        console.log("[GFP Server] STAND:", data);
        const mapId = data.mapId || 0;
        const x = data.pos?.x || 0;
        const y = data.pos?.y || 0;
        const direction = data.direction || 1;
        if (!this.validatePosition(mapId, x, y)) {
            console.log("[GFP Server] Invalid position:", { mapId, x, y });
            return;
        }
        if (!client.player) {
            client.player = this.createPlayer(client.userId);
        }
        const wasMoving = client.player.pos.x !== x || client.player.pos.y !== y;
        client.player.mapId = mapId;
        client.player.pos = { x, y };
        client.player.direction = direction;
        client.player.lastUpdate = Date.now();
        console.log(`[GFP Server] Player ${client.player.id} stood at (${x}, ${y})`);
        if (wasMoving) {
            this.broadcastPlayerStand(client.player);
        }
    }
    handleJump(client, data) {
        console.log("[GFP Server] JUMP:", data);
        const x = data.pos?.x || 0;
        const y = data.pos?.y || 0;
        if (!client.player) {
            client.player = this.createPlayer(client.userId);
        }
        if (!this.validatePosition(client.player.mapId, x, y)) {
            console.log("[GFP Server] Invalid jump position:", { x, y });
            return;
        }
        client.player.pos = { x, y };
        client.player.lastUpdate = Date.now();
        console.log(`[GFP Server] Player ${client.player.id} jumped to (${x}, ${y})`);
        this.broadcastPlayerJump(client.player);
    }
    handlePvpMove(client, data) {
        console.log("[GFP Server] PVP_MOVE:", data);
        if (!client.player) {
            client.player = this.createPlayer(client.userId);
        }
        const x = data.pos?.x || 0;
        const y = data.pos?.y || 0;
        const mapId = data.mapId || 0;
        const speed = data.speed || 200;
        const moveType = data.moveType || 1;
        const timestamp = data.timestamp || 0;
        client.player.pos = { x, y };
        client.player.mapId = mapId;
        client.player.speed = speed;
        client.player.moveType = moveType;
        client.player.lastUpdate = Date.now();
        this.broadcastPlayerPvpMove(client.player, timestamp);
    }
    handleSkill(client, data) {
        console.log("[GFP Server] SKILL:", data);
        if (!client.player) {
            console.log("[GFP Server] Player not initialized for skill");
            return;
        }
        const skillId = data.skillId || 0;
        const skillLv = data.skillLv || 1;
        const x = data.pos?.x || client.player.pos.x;
        const y = data.pos?.y || client.player.pos.y;
        const targetId = data.targetId || 0;
        const direction = data.direction || client.player.direction;
        console.log(`[GFP Server] Player ${client.player.id} used skill ${skillId} at (${x}, ${y})`);
        this.broadcastPlayerSkill(client.player, skillId, skillLv, x, y, targetId, direction);
    }
    handleItemPickup(client, data) {
        console.log("[GFP Server] ITEM_PICKUP:", data);
        if (!client.player) {
            console.log("[GFP Server] Player not initialized for item pickup");
            return;
        }
        const items = data.items || [];
        console.log(`[GFP Server] Player ${client.player.id} picked up ${items.length} items`);
    }
    handleBruise(client, data) {
        console.log("[GFP Server] ACTION_BRUISE:", data);
        if (!client.player) {
            console.log("[GFP Server] Player not initialized for bruise");
            return;
        }
        const attackerId = data.atkerID || 0;
        const targetId = data.userID || 0;
        const damage = data.decHP || 0;
        const newHp = data.hp || 0;
        const skillId = data.skillID || 0;
        const hitType = data.type || 0;
        const hitCount = data.hitCount || 1;
        console.log(`[GFP Server] Player ${targetId} took ${damage} damage from ${attackerId} (HP: ${newHp})`);
        if (newHp <= 0) {
            console.log(`[GFP Server] Player ${targetId} died (HP <= 0)`);
            this.broadcastPlayerDeath(client.player);
        }
        else {
            this.broadcastPlayerBruise(client.player, attackerId, damage, newHp, skillId, hitType, hitCount);
        }
        if (attackerId === client.player.id) {
            console.log(`[GFP Server] Player ${attackerId} dealt ${damage} damage`);
        }
    }
    handleBuffState(client, data) {
        console.log("[GFP Server] BUFF_STATE:", data);
        if (!client.player) {
            console.log("[GFP Server] Player not initialized for buff state");
            return;
        }
        const targetId = data.userID || 0;
        const buffId = data.buffID || 0;
        const buffLevel = data.buffLv || 1;
        const buffType = data.buffType || 0;
        const duration = data.duration || 0;
        const state = data.state || 0;
        console.log(`[GFP Server] Player ${targetId} buff state: ${buffId} Lv${buffLevel} (${state === 1 ? 'add' : state === 2 ? 'remove' : 'update'})`);
        if (targetId === client.player.id) {
            client.player.lastUpdate = Date.now();
        }
        this.broadcastPlayerBuff(client.player, buffId, buffLevel, buffType, duration, state);
    }
    handleMapSwitch(client, data) {
        console.log("[GFP Server] MAP_SWITCH:", data);
        if (!client.player) {
            console.log("[GFP Server] Player not initialized for map switch");
            return;
        }
        const targetMapId = data.targetMapId || data.mapId || 0;
        const teleportType = data.teleportType || 0;
        const targetX = data.position?.x;
        const targetY = data.position?.y;
        // 验证地图是否存在
        const mapConfig = this.getMapConfig(targetMapId);
        if (!mapConfig) {
            console.log(`[GFP Server] Map ${targetMapId} not found`);
            this.sendTo(client, 14005, { result: 1, error: "Map not found" });
            return;
        }
        // 检查等级限制
        if (mapConfig.requiredLevel && client.player.level < mapConfig.requiredLevel) {
            console.log(`[GFP Server] Player level ${client.player.level} too low for map ${targetMapId} (requires ${mapConfig.requiredLevel})`);
            this.sendTo(client, 14005, { result: 2, error: "Level too low" });
            return;
        }
        // 获取目标地图的出生点
        const spawnPoint = this.getSpawnPoint(targetMapId, targetX, targetY);
        // 更新玩家位置
        client.player.mapId = targetMapId;
        client.player.pos = spawnPoint;
        client.player.lastUpdate = Date.now();
        console.log(`[GFP Server] Player ${client.player.id} switched to map ${targetMapId} (${mapConfig.mapName}) at (${spawnPoint.x}, ${spawnPoint.y})`);
        // 发送切换成功响应
        const response = {
            result: 0,
            mapId: targetMapId,
            mapName: mapConfig.mapName,
            position: spawnPoint,
            newMapData: {
                width: mapConfig.width,
                height: mapConfig.height,
                isPVP: mapConfig.isPVP || false,
                isDungeon: mapConfig.isDungeon || false,
            }
        };
        this.sendTo(client, 14005, response);
        // 通知其他玩家该玩家离开了旧地图
        this.broadcastPlayerLeave(client.player.id);
    }
    getMapConfig(mapId) {
        const maps = {
            1001: { mapId: 1001, mapName: "新手村", width: 2000, height: 1500, requiredLevel: 1 },
            1002: { mapId: 1002, mapName: "竹林深处", width: 2500, height: 2000, requiredLevel: 5 },
            1003: { mapId: 1003, mapName: "虎口山谷", width: 3000, height: 2500, requiredLevel: 10 },
            1004: { mapId: 1004, mapName: "蛇影洞", width: 1800, height: 1200, requiredLevel: 15, isDungeon: true },
            1005: { mapId: 1005, mapName: "竞技场", width: 1500, height: 1500, isPVP: true },
        };
        return maps[mapId];
    }
    getSpawnPoint(mapId, x, y) {
        const defaultPoints = {
            1001: { x: 500, y: 800 },
            1002: { x: 600, y: 900 },
            1003: { x: 700, y: 1000 },
            1004: { x: 400, y: 600 },
            1005: { x: 750, y: 750 },
        };
        if (x !== undefined && y !== undefined) {
            return { x, y };
        }
        return defaultPoints[mapId] || { x: 500, y: 500 };
    }
    createPlayer(id) {
        const ws = this.getWsByClientId(id);
        const player = {
            id,
            ws: ws,
            mapId: 1001,
            pos: { x: 500, y: 300 },
            speed: 150,
            moveType: 1,
            direction: 1,
            nickName: `Player${id}`,
            roleType: 1,
            level: 1,
            hp: 1000,
            mp: 500,
            lastUpdate: Date.now(),
        };
        this.gameState.players.set(id, player);
        console.log(`[GFP Server] Created player ${id}`);
        return player;
    }
    getWsByClientId(clientId) {
        for (const [ws, client] of this.clients) {
            if (client.userId === clientId) {
                return ws;
            }
        }
        return undefined;
    }
    validatePosition(mapId, x, y) {
        if (x < 0 || x > 10000 || y < 0 || y > 10000) {
            return false;
        }
        return true;
    }
    sendTo(client, commandId, data) {
        if (client.ws.readyState === ws_1.default.OPEN) {
            const packet = PacketCodec_1.PacketEncoder.encode(commandId, data);
            client.ws.send(packet);
        }
    }
    sendError(client, commandId, message) {
        this.sendTo(client, 9999, { error: message, commandId });
    }
    broadcastPlayerMove(player) {
        const data = {
            userId: player.id,
            mapId: player.mapId,
            pos: player.pos,
            speed: player.speed,
            moveType: player.moveType,
        };
        const packet = PacketCodec_1.PacketEncoder.encode(1001, data);
        this.broadcastToOthers(player.id, packet);
    }
    broadcastPlayerStand(player) {
        const data = {
            userId: player.id,
            mapId: player.mapId,
            pos: player.pos,
            direction: player.direction,
        };
        const packet = PacketCodec_1.PacketEncoder.encode(1002, data);
        this.broadcastToOthers(player.id, packet);
    }
    broadcastPlayerJump(player) {
        const data = {
            userId: player.id,
            pos: player.pos,
        };
        const packet = PacketCodec_1.PacketEncoder.encode(1003, data);
        this.broadcastToOthers(player.id, packet);
    }
    broadcastPlayerPvpMove(player, timestamp) {
        const data = {
            userId: player.id,
            pos: player.pos,
            mapId: player.mapId,
            speed: player.speed,
            moveType: player.moveType,
            timestamp,
        };
        const packet = PacketCodec_1.PacketEncoder.encode(1004, data);
        this.broadcastToOthers(player.id, packet);
    }
    broadcastPlayerSkill(player, skillId, skillLv, x, y, targetId, direction) {
        const data = {
            userId: player.id,
            skillId,
            skillLv,
            roleId: player.roleType,
            spriteType: 1,
            pos: { x, y },
            targetId,
            direction,
        };
        const packet = PacketCodec_1.PacketEncoder.encode(2004, data);
        this.broadcastToOthers(player.id, packet);
    }
    broadcastPlayerLeave(playerId) {
        const packet = PacketCodec_1.PacketEncoder.encode(14003, { userId: playerId });
        this.broadcast(packet);
    }
    broadcastPlayerDeath(player) {
        const packet = PacketCodec_1.PacketEncoder.encode(2003, { userId: player.id, hp: 0, isDead: true });
        this.broadcast(packet);
    }
    broadcastPlayerBruise(player, attackerId, damage, newHp, skillId, hitType, hitCount) {
        const packet = PacketCodec_1.PacketEncoder.encode(2003, {
            userId: player.id,
            atkerID: attackerId,
            decHP: damage,
            hp: newHp,
            skillID: skillId,
            type: hitType,
            hitCount: hitCount
        });
        this.broadcastToOthers(player.id, packet);
    }
    broadcastPlayerBuff(player, buffId, buffLevel, buffType, duration, state) {
        const packet = PacketCodec_1.PacketEncoder.encode(2005, {
            userId: player.id,
            buffID: buffId,
            buffLv: buffLevel,
            buffType: buffType,
            duration: duration,
            state: state
        });
        this.broadcastToOthers(player.id, packet);
    }
    broadcastToOthers(excludePlayerId, data) {
        for (const [ws, client] of this.clients) {
            if (client.player && client.player.id !== excludePlayerId) {
                if (ws.readyState === ws_1.default.OPEN) {
                    ws.send(data);
                }
            }
        }
    }
    broadcast(data) {
        for (const [ws, client] of this.clients) {
            if (ws.readyState === ws_1.default.OPEN) {
                ws.send(data);
            }
        }
    }
    getPlayerCount() {
        return this.gameState.players.size;
    }
    getPlayer(playerId) {
        return this.gameState.players.get(playerId);
    }
    stop() {
        if (this.wss) {
            this.wss.close();
            this.wss = null;
            console.log("[GFP Server] Server stopped");
        }
    }
}
exports.server = new GFPServer();
exports.server.start(8080);
//# sourceMappingURL=index.js.map