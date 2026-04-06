// 地图处理器
import { Player, Client, Position } from "../types";
import { MAP_CONFIG, DEFAULT_SPAWN_POINTS } from "../types/map";

export class MapHandler {
  private players: Map<number, Player>;

  constructor(
    players: Map<number, Player>,
    private broadcastToOthers: (excludePlayerId: number, packet: Buffer) => void,
    private broadcastToMap: (mapId: number, excludePlayerId: number, packet: Buffer) => void,
    private sendToClient: (client: Client, commandId: number, data: any) => void
  ) {
    this.players = players;
  }

  /**
   * 处理地图切换请求 (CMD=14005)
   * 流程: 验证地图 → 检查权限 → 离开旧地图 → 进入新地图 → 广播通知
   */
  handleMapSwitch(client: Client, data: any): void {
    console.log("[MapHandler] MAP_SWITCH:", data);

    if (!client.player) {
      console.log("[MapHandler] Player not initialized for map switch");
      return;
    }

    const targetMapId = data.targetMapId || data.mapId || 0;
    const teleportType = data.teleportType || 0; // 0=walk, 1=teleport, 2=transition
    const targetX = data.position?.x;
    const targetY = data.position?.y;

    // 验证地图是否存在
    const mapConfig = MAP_CONFIG[targetMapId];
    if (!mapConfig) {
      console.log(`[MapHandler] Map ${targetMapId} not found`);
      this.sendToClient(client, 14005, { result: 1, mapId: targetMapId, error: "Map not found" });
      return;
    }

    // 检查等级限制
    if (mapConfig.requiredLevel && client.player.level < mapConfig.requiredLevel) {
      console.log(`[MapHandler] Player level ${client.player.level} too low for map ${targetMapId} (requires ${mapConfig.requiredLevel})`);
      this.sendToClient(client, 14005, { result: 2, mapId: targetMapId, error: "Level too low" });
      return;
    }

    // 检查副本限制（副本不能直接切换进入）
    if (mapConfig.isDungeon && teleportType === 0) {
      console.log(`[MapHandler] Map ${targetMapId} is dungeon, teleport required`);
      this.sendToClient(client, 14005, { result: 3, mapId: targetMapId, error: "Dungeon requires teleport" });
      return;
    }

    // 获取目标位置
    const spawnPoint = this.getSpawnPoint(targetMapId, targetX, targetY);
    const oldMapId = client.player.mapId;

    // 跳过同一个地图的情况
    if (oldMapId === targetMapId) {
      this.sendToClient(client, 14005, { result: 4, mapId: targetMapId, error: "Already on this map" });
      return;
    }

    // 更新玩家位置
    client.player.mapId = targetMapId;
    client.player.pos = { ...spawnPoint };
    client.player.lastUpdate = Date.now();

    console.log(`[MapHandler] Player ${client.player.id} switched from map ${oldMapId} "${MAP_CONFIG[oldMapId]?.mapName || 'Unknown'}" to map ${targetMapId} "${mapConfig.mapName}" at (${spawnPoint.x}, ${spawnPoint.y})`);

    // 发送切换成功响应给当前玩家
    this.sendToClient(client, 14005, {
      result: 0,
      mapId: targetMapId,
      mapName: mapConfig.mapName,
      position: spawnPoint,
      newMapData: {
        width: mapConfig.width,
        height: mapConfig.height,
        isPVP: mapConfig.isPVP || false,
        isDungeon: mapConfig.isDungeon || false,
        bgMusic: mapConfig.bgMusic || "",
      }
    });

    // 通知旧地图的玩家: 该玩家离开了 (CMD=14003 LEAVE_MAP)
    const leavePacket = this.encodePacket(14003, {
      userId: client.player.id,
      mapId: oldMapId,
    });
    this.broadcastToMap(oldMapId, client.player.id, leavePacket);

    // 通知新地图的玩家: 该玩家加入了 (CMD=14001 USER_LIST)
    const enterPacket = this.encodePacket(14001, {
      userId: client.player.id,
      nickName: client.player.nickName,
      roleType: client.player.roleType,
      level: client.player.level,
      mapId: targetMapId,
      pos: spawnPoint,
      direction: client.player.direction,
      hp: client.player.hp,
      mp: client.player.mp,
    });
    this.broadcastToMap(targetMapId, client.player.id, enterPacket);

    // 给新玩家发送新地图上已有的其他玩家列表
    this.sendPlayersOnMap(client, targetMapId, client.player.id);
  }

  /**
   * 获取地图上所有其他玩家的信息 (CMD=14001 / USER_LIST)
   */
  private sendPlayersOnMap(client: Client, mapId: number, excludeId: number): void {
    const playersOnMap: Array<{
      userId: number;
      nickName: string;
      roleType: number;
      level: number;
      pos: Position;
      direction: number;
      hp: number;
      mp: number;
    }> = [];

    for (const player of this.players.values()) {
      if (player.id !== excludeId && player.mapId === mapId) {
        playersOnMap.push({
          userId: player.id,
          nickName: player.nickName,
          roleType: player.roleType,
          level: player.level,
          pos: { ...player.pos },
          direction: player.direction,
          hp: player.hp,
          mp: player.mp,
        });
      }
    }

    if (playersOnMap.length > 0) {
      this.sendToClient(client, 14001, { players: playersOnMap });
    }
  }

  private getSpawnPoint(mapId: number, x?: number, y?: number): { x: number, y: number } {
    if (x !== undefined && y !== undefined) {
      return { x, y };
    }
    return DEFAULT_SPAWN_POINTS[mapId] || { x: 500, y: 500 };
  }

  private encodePacket(commandId: number, data: any): Buffer {
    const jsonStr = JSON.stringify(data);
    const body = Buffer.from(jsonStr, "utf8");
    const packet = Buffer.allocUnsafe(4 + 4 + body.length);
    packet.writeUInt32LE(4 + body.length, 0);
    packet.writeUInt32LE(commandId, 4);
    body.copy(packet, 8);
    return packet;
  }
}
