import { EventEmitter } from "events";
export type MessageHandler = (data: any, userId?: number) => void;
export declare class SocketClient extends EventEmitter {
    private ws;
    private handlers;
    private reconnectInterval;
    private maxReconnectAttempts;
    private reconnectAttempts;
    private isConnecting;
    private url;
    private userId;
    private actorId;
    constructor(url?: string);
    connect(): Promise<void>;
    private handleMessage;
    private handleReconnect;
    send(commandId: number, ...args: any[]): void;
    addHandler(commandId: number, handler: MessageHandler): void;
    removeHandler(commandId: number, handler: MessageHandler): void;
    addOneTimeHandler(commandId: number, handler: MessageHandler): void;
    setUserId(userId: number): void;
    setActorId(actorId: number): void;
    getActorId(): number;
    isConnected(): boolean;
    disconnect(): void;
    move(mapId: number, x: number, y: number, speed?: number, moveType?: number): void;
    stand(mapId: number, x: number, y: number, direction?: number): void;
    jump(x: number, y: number): void;
    useSkill(skillId: number, skillLv: number, x: number, y: number, targetId?: number): void;
}
export declare const socketClient: SocketClient;
//# sourceMappingURL=SocketClient.d.ts.map