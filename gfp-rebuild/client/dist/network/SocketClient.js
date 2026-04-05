"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.socketClient = exports.SocketClient = void 0;
const events_1 = require("events");
const ws_1 = __importDefault(require("ws"));
const CommandID_1 = require("./CommandID");
const PacketEncoder_1 = require("./PacketEncoder");
const PacketDecoder_1 = require("./PacketDecoder");
class SocketClient extends events_1.EventEmitter {
    constructor(url = "ws://localhost:8080") {
        super();
        this.ws = null;
        this.handlers = new Map();
        this.reconnectInterval = 3000;
        this.maxReconnectAttempts = 5;
        this.reconnectAttempts = 0;
        this.isConnecting = false;
        this.url = "";
        this.userId = 0;
        this.actorId = 0;
        this.url = url;
    }
    async connect() {
        if (this.ws?.readyState === ws_1.default.OPEN || this.isConnecting) {
            return;
        }
        return new Promise((resolve, reject) => {
            this.isConnecting = true;
            try {
                this.ws = new ws_1.default(this.url);
                this.ws.on("open", () => {
                    console.log("[SocketClient] Connected to", this.url);
                    this.isConnecting = false;
                    this.reconnectAttempts = 0;
                    this.emit("connect");
                    resolve();
                });
                this.ws.on("message", (data) => {
                    this.handleMessage(data);
                });
                this.ws.on("close", (code, reason) => {
                    console.log("[SocketClient] Disconnected:", code, reason.toString());
                    this.emit("disconnect", code, reason.toString());
                    this.handleReconnect();
                });
                this.ws.on("error", (error) => {
                    console.error("[SocketClient] Error:", error.message);
                    this.isConnecting = false;
                    this.emit("error", error);
                    reject(error);
                });
            }
            catch (error) {
                this.isConnecting = false;
                reject(error);
            }
        });
    }
    handleMessage(data) {
        try {
            let buffer;
            if (data instanceof Buffer) {
                const buf = data.buffer.slice(data.byteOffset, data.byteOffset + data.byteLength);
                buffer = new ArrayBuffer(buf.byteLength);
                new Uint8Array(buffer).set(new Uint8Array(buf));
            }
            else {
                buffer = data;
            }
            const packet = PacketDecoder_1.PacketDecoder.decode(buffer);
            const commandId = packet.commandId;
            const payload = packet.data;
            const handlers = this.handlers.get(commandId);
            if (handlers) {
                for (const handler of handlers) {
                    try {
                        handler(payload, this.userId);
                    }
                    catch (error) {
                        console.error(`[SocketClient] Handler error for command ${commandId}:`, error);
                    }
                }
            }
            this.emit("message", commandId, payload);
        }
        catch (error) {
            console.error("[SocketClient] Failed to decode message:", error);
        }
    }
    handleReconnect() {
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
    send(commandId, ...args) {
        if (!this.ws || this.ws.readyState !== ws_1.default.OPEN) {
            console.warn("[SocketClient] Not connected, cannot send message");
            return;
        }
        const packet = PacketEncoder_1.PacketEncoder.encode(commandId, args);
        this.ws.send(packet);
    }
    addHandler(commandId, handler) {
        if (!this.handlers.has(commandId)) {
            this.handlers.set(commandId, []);
        }
        this.handlers.get(commandId).push(handler);
    }
    removeHandler(commandId, handler) {
        const handlers = this.handlers.get(commandId);
        if (handlers) {
            const index = handlers.indexOf(handler);
            if (index !== -1) {
                handlers.splice(index, 1);
            }
        }
    }
    addOneTimeHandler(commandId, handler) {
        const wrappedHandler = (data, userId) => {
            handler(data, userId);
            this.removeHandler(commandId, wrappedHandler);
        };
        this.addHandler(commandId, wrappedHandler);
    }
    setUserId(userId) {
        this.userId = userId;
    }
    setActorId(actorId) {
        this.actorId = actorId;
    }
    getActorId() {
        return this.actorId;
    }
    isConnected() {
        return this.ws?.readyState === ws_1.default.OPEN;
    }
    disconnect() {
        if (this.ws) {
            this.reconnectAttempts = this.maxReconnectAttempts;
            this.ws.close();
            this.ws = null;
        }
    }
    move(mapId, x, y, speed = 150, moveType = 1) {
        this.send(CommandID_1.CommandID.MOVE, mapId, x, y, speed, moveType);
    }
    stand(mapId, x, y, direction = 1) {
        this.send(CommandID_1.CommandID.STAND, mapId, x, y, direction);
    }
    jump(x, y) {
        this.send(CommandID_1.CommandID.JUMP, x, y);
    }
    useSkill(skillId, skillLv, x, y, targetId = 0) {
        this.send(CommandID_1.CommandID.ACTION_SKILL, skillId, skillLv, x, y, targetId);
    }
    login(info) {
        const { session, roleTime, serverVersion = "1.0", clientType = 1, isAdult = 0, fromeGameID = "" } = info;
        this.send(CommandID_1.CommandID.LOGIN_IN, session, roleTime, serverVersion, clientType, isAdult, fromeGameID);
    }
    selectRole(roleId) {
        this.send(CommandID_1.CommandID.SELECT_ROLE, roleId);
    }
    enterGame() {
        this.send(CommandID_1.CommandID.ENTER_GAME);
    }
    logout() {
        this.send(CommandID_1.CommandID.LOGIN_OUT);
    }
}
exports.SocketClient = SocketClient;
exports.socketClient = new SocketClient();
//# sourceMappingURL=SocketClient.js.map