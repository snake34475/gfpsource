import WebSocket from "ws";
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
declare class GFPServer {
    private wss;
    private clients;
    private handlers;
    private gameState;
    start(port?: number): void;
    private startHeartbeat;
    private handleClientDisconnect;
    private handleMessage;
    private registerHandlers;
    private handleMove;
    private handleStand;
    private handleJump;
    private handlePvpMove;
    private handleSkill;
    private handleItemPickup;
    private createPlayer;
    private getWsByClientId;
    private validatePosition;
    private sendTo;
    private sendError;
    private broadcastPlayerMove;
    private broadcastPlayerStand;
    private broadcastPlayerJump;
    private broadcastPlayerPvpMove;
    private broadcastPlayerSkill;
    private broadcastPlayerLeave;
    private broadcastToOthers;
    private broadcast;
    getPlayerCount(): number;
    getPlayer(playerId: number): Player | undefined;
    stop(): void;
}
export declare const server: GFPServer;
export {};
//# sourceMappingURL=index.d.ts.map