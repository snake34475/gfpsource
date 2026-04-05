"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.BattleHandler = void 0;
class BattleHandler {
    constructor(players, broadcastFunc, broadcastToOthersFunc) {
        this.players = players;
        this.broadcastFunc = broadcastFunc;
        this.broadcastToOthersFunc = broadcastToOthersFunc;
    }
    handleBruise(client, data) {
        console.log("[BattleHandler] ACTION_BRUISE:", data);
        if (!client.player) {
            console.log("[BattleHandler] Player not initialized for bruise");
            return;
        }
        const attackerId = data.atkerID || 0;
        const targetId = data.userID || 0;
        const damage = data.decHP || 0;
        const newHp = data.hp || 0;
        const skillId = data.skillID || 0;
        const hitType = data.type || 0;
        const hitCount = data.hitCount || 1;
        console.log(`[BattleHandler] Player ${targetId} took ${damage} damage from ${attackerId} (HP: ${newHp})`);
        if (newHp <= 0) {
            console.log(`[BattleHandler] Player ${targetId} died (HP <= 0)`);
            this.broadcastFunc(client.player, { userId: targetId, hp: 0, isDead: true });
        }
        else {
            this.broadcastToOthersFunc(client.player, {
                userId: targetId,
                atkerID: attackerId,
                decHP: damage,
                hp: newHp,
                skillID: skillId,
                type: hitType,
                hitCount: hitCount,
            });
        }
        if (attackerId === client.player.id) {
            console.log(`[BattleHandler] Player ${attackerId} dealt ${damage} damage`);
        }
    }
    handleBuffState(client, data) {
        console.log("[BattleHandler] BUFF_STATE:", data);
        if (!client.player) {
            console.log("[BattleHandler] Player not initialized for buff state");
            return;
        }
        const targetId = data.userID || 0;
        const buffId = data.buffID || 0;
        const buffLevel = data.buffLv || 1;
        const buffType = data.buffType || 0;
        const duration = data.duration || 0;
        const state = data.state || 0; // 1=add, 2=remove, 3=update
        console.log(`[BattleHandler] Player ${targetId} buff state: ${buffId} Lv${buffLevel} (${state === 1 ? 'add' : state === 2 ? 'remove' : 'update'})`);
        if (targetId === client.player.id) {
            client.player.lastUpdate = Date.now();
        }
        this.broadcastToOthersFunc(client.player, {
            userId: targetId,
            buffID: buffId,
            buffLv: buffLevel,
            buffType: buffType,
            duration: duration,
            state: state,
        });
    }
}
exports.BattleHandler = BattleHandler;
//# sourceMappingURL=BattleHandler.js.map