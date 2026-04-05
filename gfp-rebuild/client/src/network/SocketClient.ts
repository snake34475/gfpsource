import { EventEmitter } from "events";
import WebSocket from "ws";
import { CommandID } from "./CommandID";
import { PacketEncoder } from "./PacketEncoder";
import { PacketDecoder, DecodedPacket } from "./PacketDecoder";

export interface LoginInfo {
  session: string;
  roleTime: number;
  serverVersion?: string;
  clientType?: number;
  isAdult?: number;
  fromeGameID?: string;
}

export interface RoleInfo {
  roleId: number;
  roleName: string;
  roleType: number;
  level: number;
  hp: number;
  mp: number;
  exp: number;
  mapId: number;
  pos: { x: number; y: number };
  direction: number;
}

export type MessageHandler = (data: any, userId?: number) => void;

export class SocketClient extends EventEmitter {
  private ws: WebSocket | null = null;
  private handlers: Map<number, MessageHandler[]> = new Map();
  private reconnectInterval: number = 3000;
  private maxReconnectAttempts: number = 5;
  private reconnectAttempts: number = 0;
  private isConnecting: boolean = false;
  private url: string = "";
  private userId: number = 0;
  private actorId: number = 0;

  constructor(url: string = "ws://localhost:8080") {
    super();
    this.url = url;
  }

  async connect(): Promise<void> {
    if (this.ws?.readyState === WebSocket.OPEN || this.isConnecting) {
      return;
    }

    return new Promise((resolve, reject) => {
      this.isConnecting = true;

      try {
        this.ws = new WebSocket(this.url);

        this.ws.on("open", () => {
          console.log("[SocketClient] Connected to", this.url);
          this.isConnecting = false;
          this.reconnectAttempts = 0;
          this.emit("connect");
          resolve();
        });

        this.ws.on("message", (data: WebSocket.Data) => {
          this.handleMessage(data);
        });

        this.ws.on("close", (code: number, reason: Buffer) => {
          console.log("[SocketClient] Disconnected:", code, reason.toString());
          this.emit("disconnect", code, reason.toString());
          this.handleReconnect();
        });

        this.ws.on("error", (error: Error) => {
          console.error("[SocketClient] Error:", error.message);
          this.isConnecting = false;
          this.emit("error", error);
          reject(error);
        });
      } catch (error) {
        this.isConnecting = false;
        reject(error);
      }
    });
  }

  private handleMessage(data: WebSocket.Data): void {
    try {
      let buffer: ArrayBuffer;
      
      if (data instanceof Buffer) {
        const buf = data.buffer.slice(data.byteOffset, data.byteOffset + data.byteLength);
        buffer = new ArrayBuffer(buf.byteLength);
        new Uint8Array(buffer).set(new Uint8Array(buf));
      } else {
        buffer = data as ArrayBuffer;
      }

      const packet = PacketDecoder.decode(buffer);
      const commandId = packet.commandId;
      const payload = packet.data;

      const handlers = this.handlers.get(commandId);
      if (handlers) {
        for (const handler of handlers) {
          try {
            handler(payload, this.userId);
          } catch (error) {
            console.error(`[SocketClient] Handler error for command ${commandId}:`, error);
          }
        }
      }

      this.emit("message", commandId, payload);
    } catch (error) {
      console.error("[SocketClient] Failed to decode message:", error);
    }
  }

  private handleReconnect(): void {
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      console.log("[SocketClient] Max reconnect attempts reached");
      this.emit("reconnectFailed");
      return;
    }

    this.reconnectAttempts++;
    console.log(`[SocketClient] Reconnecting... (${this.reconnectAttempts}/${this.maxReconnectAttempts})`);

    setTimeout(() => {
      this.connect().catch((error) => {
        console.error("[SocketClient] Reconnect failed:", error.message);
      });
    }, this.reconnectInterval);
  }

  send(commandId: number, ...args: any[]): void {
    if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
      console.warn("[SocketClient] Not connected, cannot send message");
      return;
    }

    const packet = PacketEncoder.encode(commandId, args);
    this.ws.send(packet);
  }

  addHandler(commandId: number, handler: MessageHandler): void {
    if (!this.handlers.has(commandId)) {
      this.handlers.set(commandId, []);
    }
    this.handlers.get(commandId)!.push(handler);
  }

  removeHandler(commandId: number, handler: MessageHandler): void {
    const handlers = this.handlers.get(commandId);
    if (handlers) {
      const index = handlers.indexOf(handler);
      if (index !== -1) {
        handlers.splice(index, 1);
      }
    }
  }

  addOneTimeHandler(commandId: number, handler: MessageHandler): void {
    const wrappedHandler = (data: any, userId?: number) => {
      handler(data, userId);
      this.removeHandler(commandId, wrappedHandler);
    };
    this.addHandler(commandId, wrappedHandler);
  }

  setUserId(userId: number): void {
    this.userId = userId;
  }

  setActorId(actorId: number): void {
    this.actorId = actorId;
  }

  getActorId(): number {
    return this.actorId;
  }

  isConnected(): boolean {
    return this.ws?.readyState === WebSocket.OPEN;
  }

  disconnect(): void {
    if (this.ws) {
      this.reconnectAttempts = this.maxReconnectAttempts;
      this.ws.close();
      this.ws = null;
    }
  }

  move(mapId: number, x: number, y: number, speed: number = 150, moveType: number = 1): void {
    this.send(CommandID.MOVE, mapId, x, y, speed, moveType);
  }

  stand(mapId: number, x: number, y: number, direction: number = 1): void {
    this.send(CommandID.STAND, mapId, x, y, direction);
  }

  jump(x: number, y: number): void {
    this.send(CommandID.JUMP, x, y);
  }

  useSkill(skillId: number, skillLv: number, x: number, y: number, targetId: number = 0): void {
    this.send(CommandID.ACTION_SKILL, skillId, skillLv, x, y, targetId);
  }

  login(info: LoginInfo): void {
    const { session, roleTime, serverVersion = "1.0", clientType = 1, isAdult = 0, fromeGameID = "" } = info;
    this.send(CommandID.LOGIN_IN, session, roleTime, serverVersion, clientType, isAdult, fromeGameID);
  }

  selectRole(roleId: number): void {
    this.send(CommandID.SELECT_ROLE, roleId);
  }

  enterGame(): void {
    this.send(CommandID.ENTER_GAME);
  }

  logout(): void {
    this.send(CommandID.LOGIN_OUT);
  }
}

export const socketClient = new SocketClient();