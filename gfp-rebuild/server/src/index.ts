import WebSocket, { WebSocketServer } from "ws";
import { PacketDecoder, PacketEncoder } from "./protocol/PacketCodec";

interface Position {
  x: number;
  y: number;
}

interface Player {
  id: number;
  ws: WebSocket;
  mapId: number;
  pos: Position;
  speed: number;
  moveType: number;
  direction: number;
  nickName: string;
  roleType: number;
  level: number;
  hp: number;
  mp: number;
  lastUpdate: number;
}

interface Client {
  ws: WebSocket;
  userId: number;
  actorId: number;
  player?: Player;
}

interface GameState {
  players: Map<number, Player>;
  nextPlayerId: number;
}

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
    this.startHeartbeat();
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
      this.gameState.players.delete(client.player.id);
      console.log(`[GFP Server] Player ${client.player.id} removed from game`);
      
      this.broadcastPlayerLeave(client.player.id);
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

  private createPlayer(id: number): Player {
    const ws = this.getWsByClientId(id);
    const player: Player = {
      id,
      ws: ws!,
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

  private getWsByClientId(clientId: number): WebSocket | undefined {
    for (const [ws, client] of this.clients) {
      if (client.userId === clientId) {
        return ws;
      }
    }
    return undefined;
  }

  private validatePosition(mapId: number, x: number, y: number): boolean {
    if (x < 0 || x > 10000 || y < 0 || y > 10000) {
      return false;
    }
    return true;
  }

  private sendTo(client: Client, commandId: number, data: any): void {
    if (client.ws.readyState === WebSocket.OPEN) {
      const packet = PacketEncoder.encode(commandId, data);
      client.ws.send(packet);
    }
  }

  private sendError(client: Client, commandId: number, message: string): void {
    this.sendTo(client, 9999, { error: message, commandId });
  }

  private broadcastPlayerMove(player: Player): void {
    const data = {
      userId: player.id,
      mapId: player.mapId,
      pos: player.pos,
      speed: player.speed,
      moveType: player.moveType,
    };

    const packet = PacketEncoder.encode(1001, data);
    this.broadcastToOthers(player.id, packet);
  }

  private broadcastPlayerStand(player: Player): void {
    const data = {
      userId: player.id,
      mapId: player.mapId,
      pos: player.pos,
      direction: player.direction,
    };

    const packet = PacketEncoder.encode(1002, data);
    this.broadcastToOthers(player.id, packet);
  }

  private broadcastPlayerJump(player: Player): void {
    const data = {
      userId: player.id,
      pos: player.pos,
    };

    const packet = PacketEncoder.encode(1003, data);
    this.broadcastToOthers(player.id, packet);
  }

  private broadcastPlayerPvpMove(player: Player, timestamp: number): void {
    const data = {
      userId: player.id,
      pos: player.pos,
      mapId: player.mapId,
      speed: player.speed,
      moveType: player.moveType,
      timestamp,
    };

    const packet = PacketEncoder.encode(1004, data);
    this.broadcastToOthers(player.id, packet);
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

    const packet = PacketEncoder.encode(2004, data);
    this.broadcastToOthers(player.id, packet);
  }

  private broadcastPlayerLeave(playerId: number): void {
    const packet = PacketEncoder.encode(14003, { userId: playerId });
    this.broadcast(packet);
  }

  private broadcastToOthers(excludePlayerId: number, data: Buffer): void {
    for (const [ws, client] of this.clients) {
      if (client.player && client.player.id !== excludePlayerId) {
        if (ws.readyState === WebSocket.OPEN) {
          ws.send(data);
        }
      }
    }
  }

  private broadcast(data: Buffer): void {
    for (const [ws, client] of this.clients) {
      if (ws.readyState === WebSocket.OPEN) {
        ws.send(data);
      }
    }
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