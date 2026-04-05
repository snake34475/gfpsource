// 技能相关类型定义

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

// 技能信息
export interface SkillInfo {
  id: number;
  name: string;
  description?: string;
  category: SkillCategory;
  cooldown: number;       // 冷却时间（毫秒）
  mpCost: number;        // MP消耗
  range: number;         // 攻击范围
  targetType: TargetType;
  effectType: EffectType;
  animationId?: number;
}

export enum SkillCategory {
  ATTACK = 1,      // 攻击技能
  BUFF = 2,       // 增益技能
  DEBUFF = 3,     // 减益技能
  HEAL = 4,       // 治疗技能
  SUMMON = 5,     // 召唤技能
  PASSIVE = 6,    // 被动技能
  SPECIAL = 7,    // 特殊技能
}

export enum TargetType {
  SELF = 0,       // 自身
  ENEMY = 1,      // 敌人
  ALLY = 2,       // 队友
  GROUND = 3,      // 地面（范围技能）
  ANY = 4,        // 任意
}

export enum EffectType {
  DAMAGE = 1,         // 伤害
  HEAL = 2,           // 治疗
  BUFF_ADD = 3,       // 添加Buff
  BUFF_REMOVE = 4,    // 移除Buff
  DISPLACE = 5,       // 位移
  STUN = 6,           // 眩晕
  SLOW = 7,           // 减速
  KNOCKBACK = 8,      // 击退
}

// 技能冷却数据
export interface SkillCooldown {
  skillId: number;
  lastUsed: number;    // 上次使用时间戳
  remaining: number;   // 剩余冷却时间（毫秒）
}

// 技能释放结果
export interface SkillCastResult {
  success: boolean;
  skillId: number;
  error?: string;
  manaSpent?: number;
  targetHit?: number;  // 命中目标数量
}

// 技能效果数据（服务端下发）
export interface SkillEffectData {
  skillId: number;
  casterId: number;
  targetId: number;
  effectType: EffectType;
  value: number;           // 效果值（伤害/治疗量等）
  duration?: number;       // 持续时间
  pos?: Position;          // 效果位置
}

// 技能配置
export const SKILL_CONFIG: Record<number, SkillInfo> = {
  1001: { id: 1001, name: "普通攻击", category: SkillCategory.ATTACK, cooldown: 500, mpCost: 0, range: 100, targetType: TargetType.ENEMY, effectType: EffectType.DAMAGE },
  1002: { id: 1002, name: "重击", category: SkillCategory.ATTACK, cooldown: 1500, mpCost: 20, range: 150, targetType: TargetType.ENEMY, effectType: EffectType.DAMAGE },
  1003: { id: 1003, name: "旋风斩", category: SkillCategory.ATTACK, cooldown: 3000, mpCost: 50, range: 200, targetType: TargetType.GROUND, effectType: EffectType.DAMAGE },
  2001: { id: 2001, name: "防御", category: SkillCategory.BUFF, cooldown: 5000, mpCost: 30, range: 0, targetType: TargetType.SELF, effectType: EffectType.BUFF_ADD },
  2002: { id: 2002, name: "治疗", category: SkillCategory.HEAL, cooldown: 8000, mpCost: 40, range: 300, targetType: TargetType.ALLY, effectType: EffectType.HEAL },
};