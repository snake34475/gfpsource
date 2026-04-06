import { Player, Client } from "../types";
export declare class MapHandler {
    private broadcastToOthers;
    private broadcastToMap;
    private sendToClient;
    private players;
    constructor(players: Map<number, Player>, broadcastToOthers: (excludePlayerId: number, packet: Buffer) => void, broadcastToMap: (mapId: number, excludePlayerId: number, packet: Buffer) => void, sendToClient: (client: Client, commandId: number, data: any) => void);
    /**
     * 处理地图切换请求 (CMD=14005)
     * 流程: 验证地图 → 检查权限 → 离开旧地图 → 进入新地图 → 广播通知
     */
    handleMapSwitch(client: Client, data: any): void;
    /**
     * 获取地图上所有其他玩家的信息 (CMD=14001 / USER_LIST)
     */
    private sendPlayersOnMap;
    private getSpawnPoint;
    private encodePacket;
}
//# sourceMappingURL=MapHandler.d.ts.map