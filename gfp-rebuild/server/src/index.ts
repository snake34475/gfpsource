import WebSocket, { WebSocketServer } from "ws";
import { PacketDecoder } from "./protocol/PacketCodec";
import { MAP_CONFIG, DEFAULT_SPAWN_POINTS } from "./types/map";
import { MapHandler } from "./handlers/MapHandler";
import { Position, Player, Client, GameState } from "./types";

class GFPServer {
  private wss: WebSocketServer | null = null;
  private clients: Map<WebSocket, Client> = new Map();
  private handlers: Map<number, (client: Client, data: any) => void> = new Map();
  private gameState: GameState = {
    players: new Map(),
    nextPlayerId: 1,
  };

  start(port: number = 8080): void {
    this.wss = new WebSocketServer({ port });

    console.log(`[GFP Server] WebSocket server started on port ${port}`);
    console.log(`[GFP Server] Connect via ws://localhost:${port}`);

    this.wss.on("connection", (ws: WebSocket) => {
      console.log("[GFP Server] New client connected");

      const clientId = this.gameState.nextPlayerId++;
      const client: Client = {
        ws,
        userId: clientId,
        actorId: 0,
        player: undefined
      };
      this.clients.set(ws, client);

      ws.on("message", (data: Buffer) => {
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
    this.initMapHandler();
    this.startHeartbeat();
  }

  private initMapHandler(): void {
    this.handlers.set(14005, (client, data) => {
      const mapHandler = new MapHandler(
        this.gameState.players,
        (excludeId, packet) => this.broadcastToOthers(excludeId, packet),
        (mapId, excludeId, packet) => this.broadcastToMap(mapId, excludeId, packet),
        (c, cmd, d) => this.sendTo(c, cmd, d)
      );
      mapHandler.handleMapSwitch(client, data);
    });
  }

  private startHeartbeat(): void {
    setInterval(() => {
      const now = Date.now();
      for (const [ws, client] of this.clients) {
        if (client.player && ws.readyState === WebSocket.OPEN) {
          if (now - client.player.lastUpdate > 60000) {
            console.log(`[GFP Server] Player ${client.player.id} heartbeat timeout`);
          }
        }
      }
    }, 30000);
  }

  private handleClientDisconnect(client: Client): void {
    if (client.player) {
      const oldMapId = client.player.mapId;
      this.gameState.players.delete(client.player.id);
      console.log(`[GFP Server] Player ${client.player.id} removed from game`);

      // 通知同地图的其他玩家
      this.broadcastJsonMap(oldMapId, client.player.id, 14003, {
        userId: client.player.id,
        mapId: oldMapId,
      });
    }
  }

  private handleMessage(client: Client, data: Buffer): void {
    try {
      const packet = PacketDecoder.decode(data);
      const { header, data: payload } = packet;
      const commandId = header.commandId;

      console.log(`[GFP Server] Received: CMD=${commandId}`, JSON.stringify(payload));

      const handler = this.handlers.get(commandId);
      if (handler) {
        handler(client, payload);
      } else {
        console.log(`[GFP Server] No handler for command ${commandId}`);
      }
    } catch (error) {
      console.error("[GFP Server] Failed to handle message:", error);
    }
  }

  private registerHandlers(): void {
    this.handlers.set(1001, this.handleMove.bind(this));
    this.handlers.set(1002, this.handleStand.bind(this));
    this.handlers.set(1003, this.handleJump.bind(this));
    this.handlers.set(1004, this.handlePvpMove.bind(this));
    this.handlers.set(2004, this.handleSkill.bind(this));
    this.handlers.set(3001, this.handleItemPickup.bind(this));
    this.handlers.set(2003, this.handleBruise.bind(this));
    this.handlers.set(2005, this.handleBuffState.bind(this));
    // 登录/选角/进入游戏
    this.handlers.set(10001, (client, data) => this.handleLogin(client, data));
    this.handlers.set(10004, (client, data) => this.handleRoleList(client, data));
    this.handlers.set(10005, (client, data) => this.handleSelectRole(client, data));
    this.handlers.set(10006, (client, data) => this.handleEnterGame(client, data));
    // 请求当前地图上的玩家列表（客户端场景加载完成后调用）
    this.handlers.set(10007, (client, data) => this.handleGetMapPlayers(client, data));
    // MAP_SWITCH 在 initMapHandler 中注册
  }

  private handleMove(client: Client, data: any): void {
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

  private handleStand(client: Client, data: any): void {
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

  private handleJump(client: Client, data: any): void {
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

  private handlePvpMove(client: Client, data: any): void {
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

  private handleSkill(client: Client, data: any): void {
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

  private handleItemPickup(client: Client, data: any): void {
    console.log("[GFP Server] ITEM_PICKUP:", data);

    if (!client.player) {
      console.log("[GFP Server] Player not initialized for item pickup");
      return;
    }

    const items = data.items || [];
    console.log(`[GFP Server] Player ${client.player.id} picked up ${items.length} items`);
  }

  private handleBruise(client: Client, data: any): void {
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
    } else {
      this.broadcastPlayerBruise(client.player, attackerId, damage, newHp, skillId, hitType, hitCount);
    }

    if (attackerId === client.player.id) {
      console.log(`[GFP Server] Player ${attackerId} dealt ${damage} damage`);
    }
  }

  private handleBuffState(client: Client, data: any): void {
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

  private createPlayer(id: number, mapId: number = 1001): Player {
    const ws = this.getWsByClientId(id);
    const spawnPoint = DEFAULT_SPAWN_POINTS[mapId] || { x: 500, y: 800 };
    const player: Player = {
      id,
      ws: ws!,
      mapId,
      pos: { x: spawnPoint.x, y: spawnPoint.y },
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

  private getWsByClientId(clientId: number): WebSocket | undefined {
    for (const [ws, client] of this.clients) {
      if (client.userId === clientId) {
        return ws;
      }
    }
    return undefined;
  }

  private validatePosition(mapId: number, x: number, y: number): boolean {
    const mapConfig = MAP_CONFIG[mapId];
    if (mapConfig) {
      return x >= 0 && x <= mapConfig.width && y >= 0 && y <= mapConfig.height;
    }
    return x >= 0 && x <= 10000 && y >= 0 && y <= 10000;
  }

  private sendTo(client: Client, commandId: number, data: any): void {
    if (client.ws.readyState === WebSocket.OPEN) {
      const body = Buffer.from(JSON.stringify(data), 'utf8');
      const length = 4 + body.length;
      const packet = Buffer.allocUnsafe(8 + body.length);
      packet.writeUInt32LE(length, 0);
      packet.writeUInt32LE(commandId, 4);
      body.copy(packet, 8);
      client.ws.send(packet);
    }
  }

  private broadcastJson(excludePlayerId: number, commandId: number, data: any): void {
    const body = Buffer.from(JSON.stringify(data), 'utf8');
    const length = 4 + body.length;
    const packet = Buffer.allocUnsafe(8 + body.length);
    packet.writeUInt32LE(length, 0);
    packet.writeUInt32LE(commandId, 4);
    body.copy(packet, 8);
    for (const [ws, client] of this.clients) {
      if (client.player && client.player.id !== excludePlayerId && ws.readyState === WebSocket.OPEN) {
        ws.send(packet);
      }
    }
  }

  private broadcastJsonAll(commandId: number, data: any): void {
    const body = Buffer.from(JSON.stringify(data), 'utf8');
    const length = 4 + body.length;
    const packet = Buffer.allocUnsafe(8 + body.length);
    packet.writeUInt32LE(length, 0);
    packet.writeUInt32LE(commandId, 4);
    body.copy(packet, 8);
    for (const [ws, client] of this.clients) {
      if (ws.readyState === WebSocket.OPEN) {
        ws.send(packet);
      }
    }
  }

  private broadcastJsonMap(mapId: number, excludePlayerId: number, commandId: number, data: any): void {
    const body = Buffer.from(JSON.stringify(data), 'utf8');
    const length = 4 + body.length;
    const packet = Buffer.allocUnsafe(8 + body.length);
    packet.writeUInt32LE(length, 0);
    packet.writeUInt32LE(commandId, 4);
    body.copy(packet, 8);
    for (const [ws, client] of this.clients) {
      if (client.player && client.player.id !== excludePlayerId && client.player.mapId === mapId && ws.readyState === WebSocket.OPEN) {
        ws.send(packet);
      }
    }
  }

  private sendError(client: Client, commandId: number, message: string): void {
    this.sendTo(client, 9999, { error: message, commandId });
  }

  private broadcastPlayerMove(player: Player): void {
    this.broadcastJson(player.id, 1001, {
      userId: player.id,
      mapId: player.mapId,
      pos: player.pos,
      speed: player.speed,
      moveType: player.moveType,
    });
  }

  private broadcastPlayerStand(player: Player): void {
    this.broadcastJson(player.id, 1002, {
      userId: player.id,
      mapId: player.mapId,
      pos: player.pos,
      direction: player.direction,
    });
  }

  private broadcastPlayerJump(player: Player): void {
    this.broadcastJson(player.id, 1003, {
      userId: player.id,
      pos: player.pos,
    });
  }

  private broadcastPlayerPvpMove(player: Player, timestamp: number): void {
    this.broadcastJson(player.id, 1004, {
      userId: player.id,
      pos: player.pos,
      mapId: player.mapId,
      speed: player.speed,
      moveType: player.moveType,
      timestamp,
    });
  }

  private broadcastPlayerSkill(
    player: Player,
    skillId: number,
    skillLv: number,
    x: number,
    y: number,
    targetId: number,
    direction: number
  ): void {
    this.broadcastJson(player.id, 2004, {
      userId: player.id,
      skillId,
      skillLv,
      roleId: player.roleType,
      spriteType: 1,
      pos: { x, y },
      targetId,
      direction,
    });
  }

  private broadcastPlayerLeave(playerId: number): void {
    this.broadcastJsonAll(14003, { userId: playerId });
  }

  private broadcastPlayerDeath(player: Player): void {
    this.broadcastJsonAll(2003, { userId: player.id, hp: 0, isDead: true });
  }

  private broadcastPlayerBruise(player: Player, attackerId: number, damage: number, newHp: number, skillId: number, hitType: number, hitCount: number): void {
    this.broadcastJson(player.id, 2003, {
      userId: player.id,
      atkerID: attackerId,
      decHP: damage,
      hp: newHp,
      skillID: skillId,
      type: hitType,
      hitCount: hitCount
    });
  }

  private broadcastPlayerBuff(player: Player, buffId: number, buffLevel: number, buffType: number, duration: number, state: number): void {
    this.broadcastJson(player.id, 2005, {
      userId: player.id,
      buffID: buffId,
      buffLv: buffLevel,
      buffType: buffType,
      duration: duration,
      state: state
    });
  }

  /**
   * 广播给所有玩家
   */
  private broadcast(data: Buffer): void {
    for (const [ws, client] of this.clients) {
      if (ws.readyState === WebSocket.OPEN) {
        ws.send(data);
      }
    }
  }

  /**
   * 广播给除了指定玩家之外的所有人
   */
  private broadcastToOthers(excludePlayerId: number, data: Buffer): void {
    for (const [ws, client] of this.clients) {
      if (client.player && client.player.id !== excludePlayerId) {
        if (ws.readyState === WebSocket.OPEN) {
          ws.send(data);
        }
      }
    }
  }

  /**
   * 仅广播给同一地图上的玩家
   */
  private broadcastToMap(mapId: number, excludePlayerId: number, data: Buffer): void {
    for (const [ws, client] of this.clients) {
      if (client.player && client.player.id !== excludePlayerId && client.player.mapId === mapId) {
        if (ws.readyState === WebSocket.OPEN) {
          ws.send(data);
        }
      }
    }
  }

  /**
   * 获取地图上指定玩家的信息
   */
  private sendMapPlayersToClient(client: Client, mapId: number, excludeId: number): void {
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

    for (const player of this.gameState.players.values()) {
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
      this.sendTo(client, 14001, { players: playersOnMap });
    }
  }

  // --- Login handlers ---

  private handleLogin(client: Client, data: any): void {
    console.log("[GFP Server] LOGIN:", data);
    const username = data.username || "Guest";
    client.userId = Math.floor(Math.random() * 10000) + 1;

    this.sendTo(client, 10001, {
      result: 0,
      username,
      serverTime: Date.now(),
    });

    this.sendTo(client, 10004, {
      roles: [
        {
          actorId: 1,
          nickName: username,
          roleType: 1,
          level: 1,
          mapId: 1001,
          mapName: "新手村",
        }
      ]
    });
  }

  private handleRoleList(client: Client, data: any): void {
    console.log("[GFP Server] ROLE_LIST:", data);
    this.sendTo(client, 10004, {
      roles: [
        {
          actorId: 1,
          nickName: client.userId.toString(),
          roleType: 1,
          level: 1,
          mapId: 1001,
          mapName: "新手村",
        }
      ]
    });
  }

  private handleSelectRole(client: Client, data: any): void {
    console.log("[GFP Server] SELECT_ROLE:", data);
    const actorId = data.actorId || 1;
    client.actorId = actorId;

    this.sendTo(client, 10005, {
      result: 0,
      actorId,
    });
  }

  private handleEnterGame(client: Client, data: any): void {
    console.log("[GFP Server] ENTER_GAME:", data);

    if (!client.player) {
      client.player = this.createPlayer(client.userId);
    }

    const mapConfig = MAP_CONFIG[client.player.mapId];
    const spawnPoint = DEFAULT_SPAWN_POINTS[client.player.mapId];

    this.sendTo(client, 10006, {
      result: 0,
      userId: client.player.id,
      nickName: client.player.nickName,
      roleType: client.player.roleType,
      level: client.player.level,
      mapId: client.player.mapId,
      mapName: mapConfig?.mapName || "新手村",
      pos: spawnPoint,
    });

    // 向同地图其他玩家广播新玩家
    this.broadcastJsonMap(client.player.mapId, client.player.id, 14001, {
      userId: client.player.id,
      nickName: client.player.nickName,
      roleType: client.player.roleType,
      level: client.player.level,
      mapId: client.player.mapId,
      pos: spawnPoint,
      direction: client.player.direction,
      hp: client.player.hp,
      mp: client.player.mp,
    });

    // 不再立即发送玩家列表，改为客户端 GameScene 加载完成后主动请求
  }

  private handleGetMapPlayers(client: Client, data: any): void {
    console.log("[GFP Server] GET_MAP_PLAYERS:", client.player?.id, data);
    if (!client.player) return;
    this.sendMapPlayersToClient(client, client.player.mapId, client.player.id);
  }

  getPlayerCount(): number {
    return this.gameState.players.size;
  }

  getPlayer(playerId: number): Player | undefined {
    return this.gameState.players.get(playerId);
  }

  stop(): void {
    if (this.wss) {
      this.wss.close();
      this.wss = null;
      console.log("[GFP Server] Server stopped");
    }
  }
}

export const server = new GFPServer();
server.start(8080);
