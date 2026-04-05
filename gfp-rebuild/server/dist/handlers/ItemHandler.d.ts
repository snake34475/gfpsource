import { Player, Client } from "../types";
export declare class ItemHandler {
    private players;
    private broadcastFunc;
    constructor(players: Map<number, Player>, broadcastFunc: (player: Player, data: any) => void);
    handleItemPickup(client: Client, data: any): void;
}
//# sourceMappingURL=ItemHandler.d.ts.map