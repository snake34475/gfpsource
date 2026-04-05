import { Player, Client } from "../types";
export declare class BattleHandler {
    private players;
    private broadcastFunc;
    private broadcastToOthersFunc;
    constructor(players: Map<number, Player>, broadcastFunc: (player: Player, data: any) => void, broadcastToOthersFunc: (player: Player, data: any) => void);
    handleBruise(client: Client, data: any): void;
    handleBuffState(client: Client, data: any): void;
}
//# sourceMappingURL=BattleHandler.d.ts.map