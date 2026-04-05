import { Player, Client } from "../types";
export declare class SkillHandler {
    private players;
    private broadcastFunc;
    constructor(players: Map<number, Player>, broadcastFunc: (player: Player, data: any) => void);
    handleSkill(client: Client, data: any): void;
}
//# sourceMappingURL=SkillHandler.d.ts.map