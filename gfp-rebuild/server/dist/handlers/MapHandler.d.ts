import { Player, Client } from "../types";
export declare class MapHandler {
    private players;
    private broadcastFunc;
    private sendToFunc;
    constructor(players: Map<number, Player>, broadcastFunc: (player: Player, data: any) => void, sendToFunc: (client: Client, commandId: number, data: any) => void);
    handleMapSwitch(client: Client, data: any): void;
    private getMapConfig;
    private getSpawnPoint;
}
//# sourceMappingURL=MapHandler.d.ts.map