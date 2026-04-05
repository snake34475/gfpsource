"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ItemHandler = void 0;
class ItemHandler {
    constructor(players, broadcastFunc) {
        this.players = players;
        this.broadcastFunc = broadcastFunc;
    }
    handleItemPickup(client, data) {
        console.log("[ItemHandler] ITEM_PICKUP:", data);
        if (!client.player) {
            console.log("[ItemHandler] Player not initialized");
            return;
        }
        const items = data.items || [];
        console.log(`[ItemHandler] Player ${client.player.id} picked up ${items.length} items`);
        // 可以在这里添加物品到玩家背包的逻辑
        // 目前只是记录日志
        // 广播给其他玩家（如果有掉落物品显示需求）
        if (items.length > 0) {
            this.broadcastFunc(client.player, {
                userId: client.player.id,
                items: items.map((item) => ({
                    itemId: item.itemId || 0,
                    count: item.count || 1,
                })),
            });
        }
    }
}
exports.ItemHandler = ItemHandler;
//# sourceMappingURL=ItemHandler.js.map