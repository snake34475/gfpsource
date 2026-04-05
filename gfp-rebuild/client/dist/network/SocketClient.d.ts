import { EventEmitter } from "events";
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
    pos: {
        x: number;
        y: number;
    };
    direction: number;
}
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
    login(info: LoginInfo): void;
    selectRole(roleId: number): void;
    enterGame(): void;
    logout(): void;
}
export declare const socketClient: SocketClient;
//# sourceMappingURL=SocketClient.d.ts.map