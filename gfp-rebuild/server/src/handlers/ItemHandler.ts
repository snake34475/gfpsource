// 物品处理器
import { Player, Client } from "../types";

export class ItemHandler {
  private players: Map<number, Player>;
  private broadcastFunc: (player: Player, data: any) => void;

  constructor(
    players: Map<number, Player>,
    broadcastFunc: (player: Player, data: any) => void
  ) {
    this.players = players;
    this.broadcastFunc = broadcastFunc;
  }

  handleItemPickup(client: Client, data: any): void {
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
        items: items.map((item: any) => ({
          itemId: item.itemId || 0,
          count: item.count || 1,
        })),
      });
    }
  }
}