import { Player, Client } from "../types";
export interface Position {
    x: number;
    y: number;
}
export declare class MoveHandler {
    private players;
    private broadcastFunc;
    constructor(players: Map<number, Player>, broadcastFunc: (player: Player, data: any) => void);
    handleMove(client: Client, data: any): void;
    handleStand(client: Client, data: any): void;
    handleJump(client: Client, data: any): void;
    handlePvpMove(client: Client, data: any): void;
    private validatePosition;
}
//# sourceMappingURL=MoveHandler.d.ts.map