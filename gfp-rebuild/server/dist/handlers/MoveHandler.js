"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MoveHandler = void 0;
class MoveHandler {
    constructor(players, broadcastFunc) {
        this.players = players;
        this.broadcastFunc = broadcastFunc;
    }
    handleMove(client, data) {
        console.log("[MoveHandler] MOVE:", data);
        const mapId = data.mapId || 0;
        const x = data.pos?.x || 0;
        const y = data.pos?.y || 0;
        const speed = data.speed || 150;
        const moveType = data.moveType || 1;
        if (!this.validatePosition(mapId, x, y)) {
            console.log("[MoveHandler] Invalid position:", { mapId, x, y });
            return;
        }
        if (!client.player) {
            console.log("[MoveHandler] Player not initialized");
            return;
        }
        client.player.mapId = mapId;
        client.player.pos = { x, y };
        client.player.speed = speed;
        client.player.moveType = moveType;
        client.player.lastUpdate = Date.now();
        console.log(`[MoveHandler] Player ${client.player.id} moved to (${x}, ${y}) in map ${mapId}`);
        this.broadcastFunc(client.player, {
            userId: client.player.id,
            mapId: client.player.mapId,
            pos: client.player.pos,
            speed: client.player.speed,
            moveType: client.player.moveType,
        });
    }
    handleStand(client, data) {
        console.log("[MoveHandler] STAND:", data);
        if (!client.player)
            return;
        const mapId = data.mapId || 0;
        const x = data.pos?.x || 0;
        const y = data.pos?.y || 0;
        const direction = data.direction || 1;
        if (!this.validatePosition(mapId, x, y))
            return;
        client.player.mapId = mapId;
        client.player.pos = { x, y };
        client.player.direction = direction;
        client.player.lastUpdate = Date.now();
        console.log(`[MoveHandler] Player ${client.player.id} stood at (${x}, ${y})`);
        this.broadcastFunc(client.player, {
            userId: client.player.id,
            mapId: client.player.mapId,
            pos: client.player.pos,
            direction: client.player.direction,
        });
    }
    handleJump(client, data) {
        console.log("[MoveHandler] JUMP:", data);
        if (!client.player)
            return;
        const x = data.pos?.x || 0;
        const y = data.pos?.y || 0;
        client.player.pos = { x, y };
        client.player.lastUpdate = Date.now();
        console.log(`[MoveHandler] Player ${client.player.id} jumped to (${x}, ${y})`);
        this.broadcastFunc(client.player, {
            userId: client.player.id,
            pos: client.player.pos,
        });
    }
    handlePvpMove(client, data) {
        console.log("[MoveHandler] PVP_MOVE:", data);
        if (!client.player)
            return;
        const mapId = data.mapId || 0;
        const x = data.pos?.x || 0;
        const y = data.pos?.y || 0;
        const speed = data.speed || 150;
        const moveType = data.moveType || 1;
        const timestamp = data.timestamp || 0;
        if (!this.validatePosition(mapId, x, y))
            return;
        client.player.mapId = mapId;
        client.player.pos = { x, y };
        client.player.speed = speed;
        client.player.moveType = moveType;
        client.player.lastUpdate = Date.now();
        console.log(`[MoveHandler] Player ${client.player.id} pvp-moved to (${x}, ${y})`);
        this.broadcastFunc(client.player, {
            userId: client.player.id,
            pos: client.player.pos,
            mapId: client.player.mapId,
            speed: client.player.speed,
            moveType: client.player.moveType,
            timestamp: timestamp,
        });
    }
    validatePosition(mapId, x, y) {
        // 简单验证：坐标必须在合理范围内
        if (mapId <= 0 || x < 0 || y < 0 || x > 10000 || y > 10000) {
            return false;
        }
        return true;
    }
}
exports.MoveHandler = MoveHandler;
//# sourceMappingURL=MoveHandler.js.map