export interface SkillData {
    skillId: number;
    skillLv: number;
    roleId: number;
    spriteType: number;
    pos: Position;
    targetId: number;
    direction: number;
}
export interface Position {
    x: number;
    y: number;
}
export interface SkillInfo {
    id: number;
    name: string;
    description?: string;
    category: SkillCategory;
    cooldown: number;
    mpCost: number;
    range: number;
    targetType: TargetType;
    effectType: EffectType;
    animationId?: number;
}
export declare enum SkillCategory {
    ATTACK = 1,// 攻击技能
    BUFF = 2,// 增益技能
    DEBUFF = 3,// 减益技能
    HEAL = 4,// 治疗技能
    SUMMON = 5,// 召唤技能
    PASSIVE = 6,// 被动技能
    SPECIAL = 7
}
export declare enum TargetType {
    SELF = 0,// 自身
    ENEMY = 1,// 敌人
    ALLY = 2,// 队友
    GROUND = 3,// 地面（范围技能）
    ANY = 4
}
export declare enum EffectType {
    DAMAGE = 1,// 伤害
    HEAL = 2,// 治疗
    BUFF_ADD = 3,// 添加Buff
    BUFF_REMOVE = 4,// 移除Buff
    DISPLACE = 5,// 位移
    STUN = 6,// 眩晕
    SLOW = 7,// 减速
    KNOCKBACK = 8
}
export interface SkillCooldown {
    skillId: number;
    lastUsed: number;
    remaining: number;
}
export interface SkillCastResult {
    success: boolean;
    skillId: number;
    error?: string;
    manaSpent?: number;
    targetHit?: number;
}
export interface SkillEffectData {
    skillId: number;
    casterId: number;
    targetId: number;
    effectType: EffectType;
    value: number;
    duration?: number;
    pos?: Position;
}
export declare const SKILL_CONFIG: Record<number, SkillInfo>;
//# sourceMappingURL=skill.d.ts.map