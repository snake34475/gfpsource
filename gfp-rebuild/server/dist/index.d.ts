import { Player } from "./types";
declare class GFPServer {
    private wss;
    private clients;
    private handlers;
    private gameState;
    start(port?: number): void;
    private initMapHandler;
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
    private handleBruise;
    private handleBuffState;
    private createPlayer;
    private getWsByClientId;
    private validatePosition;
    private sendTo;
    private broadcastJson;
    private broadcastJsonAll;
    private broadcastJsonMap;
    private sendError;
    private broadcastPlayerMove;
    private broadcastPlayerStand;
    private broadcastPlayerJump;
    private broadcastPlayerPvpMove;
    private broadcastPlayerSkill;
    private broadcastPlayerLeave;
    private broadcastPlayerDeath;
    private broadcastPlayerBruise;
    private broadcastPlayerBuff;
    /**
     * 广播给所有玩家
     */
    private broadcast;
    /**
     * 广播给除了指定玩家之外的所有人
     */
    private broadcastToOthers;
    /**
     * 仅广播给同一地图上的玩家
     */
    private broadcastToMap;
    /**
     * 获取地图上指定玩家的信息
     */
    private sendMapPlayersToClient;
    private handleLogin;
    private handleRoleList;
    private handleSelectRole;
    private handleEnterGame;
    private handleGetMapPlayers;
    getPlayerCount(): number;
    getPlayer(playerId: number): Player | undefined;
    stop(): void;
}
export declare const server: GFPServer;
export {};
//# sourceMappingURL=index.d.ts.map