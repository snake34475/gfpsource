// 技能处理器
import { Player, Client } from "../types";

export class SkillHandler {
  private players: Map<number, Player>;
  private broadcastFunc: (player: Player, data: any) => void;

  constructor(
    players: Map<number, Player>,
    broadcastFunc: (player: Player, data: any) => void
  ) {
    this.players = players;
    this.broadcastFunc = broadcastFunc;
  }

  handleSkill(client: Client, data: any): void {
    console.log("[SkillHandler] ACTION_SKILL:", data);

    if (!client.player) {
      console.log("[SkillHandler] Player not initialized");
      return;
    }

    const skillId = data.skillId || 0;
    const skillLv = data.skillLv || 1;
    const x = data.pos?.x || 0;
    const y = data.pos?.y || 0;
    const targetId = data.targetId || 0;
    const direction = data.direction || 1;

    console.log(`[SkillHandler] Player ${client.player.id} used skill ${skillId} (Lv${skillLv}) at (${x}, ${y})`);

    // 更新玩家位置
    client.player.pos = { x, y };
    client.player.lastUpdate = Date.now();

    // 广播给其他玩家
    this.broadcastFunc(client.player, {
      userId: client.player.id,
      skillId: skillId,
      skillLv: skillLv,
      roleId: client.player.roleType,
      spriteType: 1,
      pos: { x, y },
      targetId: targetId,
      direction: direction,
    });
  }
}