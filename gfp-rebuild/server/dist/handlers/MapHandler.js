"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MapHandler = void 0;
class MapHandler {
    constructor(players, broadcastFunc, sendToFunc) {
        this.players = players;
        this.broadcastFunc = broadcastFunc;
        this.sendToFunc = sendToFunc;
    }
    handleMapSwitch(client, data) {
        console.log("[MapHandler] MAP_SWITCH:", data);
        if (!client.player) {
            console.log("[MapHandler] Player not initialized for map switch");
            return;
        }
        const targetMapId = data.targetMapId || data.mapId || 0;
        const teleportType = data.teleportType || 0;
        const targetX = data.position?.x;
        const targetY = data.position?.y;
        // 验证地图是否存在
        const mapConfig = this.getMapConfig(targetMapId);
        if (!mapConfig) {
            console.log(`[MapHandler] Map ${targetMapId} not found`);
            this.sendToFunc(client, 14005, { result: 1, error: "Map not found" });
            return;
        }
        // 检查等级限制
        if (mapConfig.requiredLevel && client.player.level < mapConfig.requiredLevel) {
            console.log(`[MapHandler] Player level ${client.player.level} too low for map ${targetMapId} (requires ${mapConfig.requiredLevel})`);
            this.sendToFunc(client, 14005, { result: 2, error: "Level too low" });
            return;
        }
        // 获取目标地图的出生点
        const spawnPoint = this.getSpawnPoint(targetMapId, targetX, targetY);
        // 记录旧地图
        const oldMapId = client.player.mapId;
        // 更新玩家位置
        client.player.mapId = targetMapId;
        client.player.pos = spawnPoint;
        client.player.lastUpdate = Date.now();
        console.log(`[MapHandler] Player ${client.player.id} switched from map ${oldMapId} to ${targetMapId} (${mapConfig.mapName}) at (${spawnPoint.x}, ${spawnPoint.y})`);
        // 发送切换成功响应给当前玩家
        this.sendToFunc(client, 14005, {
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
        });
        // 通知其他玩家该玩家离开了旧地图
        this.broadcastFunc({ id: -1, mapId: oldMapId, pos: { x: 0, y: 0 } }, { userId: client.player.id });
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
}
exports.MapHandler = MapHandler;
//# sourceMappingURL=MapHandler.js.map