// @vitest-environment node
import { describe, it, expect } from 'vitest';
import { Position, MoveType, PlayerState } from '../src/types/move';
import { SkillCategory, TargetType, EffectType, SKILL_CONFIG } from '../src/types/skill';

describe('移动类型测试', () => {
  it('Position 类型正确', () => {
    const pos: Position = { x: 100, y: 200 };
    expect(pos.x).toBe(100);
    expect(pos.y).toBe(200);
  });

  it('MoveType 枚举值正确', () => {
    expect(MoveType.WALK).toBe(1);
    expect(MoveType.RUN).toBe(2);
    expect(MoveType.SPRINT).toBe(3);
    expect(MoveType.SWIM).toBe(4);
    expect(MoveType.FLY).toBe(5);
  });

  it('PlayerState 枚举值正确', () => {
    expect(PlayerState.IDLE).toBe(0);
    expect(PlayerState.MOVE).toBe(1);
    expect(PlayerState.JUMP).toBe(2);
    expect(PlayerState.ATTACK).toBe(3);
    expect(PlayerState.SKILL).toBe(4);
    expect(PlayerState.DEAD).toBe(5);
  });
});

describe('技能类型测试', () => {
  it('SkillCategory 枚举值正确', () => {
    expect(SkillCategory.ATTACK).toBe(1);
    expect(SkillCategory.BUFF).toBe(2);
    expect(SkillCategory.DEBUFF).toBe(3);
    expect(SkillCategory.HEAL).toBe(4);
    expect(SkillCategory.SUMMON).toBe(5);
    expect(SkillCategory.PASSIVE).toBe(6);
    expect(SkillCategory.SPECIAL).toBe(7);
  });

  it('TargetType 枚举值正确', () => {
    expect(TargetType.SELF).toBe(0);
    expect(TargetType.ENEMY).toBe(1);
    expect(TargetType.ALLY).toBe(2);
    expect(TargetType.GROUND).toBe(3);
    expect(TargetType.ANY).toBe(4);
  });

  it('EffectType 枚举值正确', () => {
    expect(EffectType.DAMAGE).toBe(1);
    expect(EffectType.HEAL).toBe(2);
    expect(EffectType.BUFF_ADD).toBe(3);
    expect(EffectType.BUFF_REMOVE).toBe(4);
    expect(EffectType.DISPLACE).toBe(5);
    expect(EffectType.STUN).toBe(6);
    expect(EffectType.SLOW).toBe(7);
    expect(EffectType.KNOCKBACK).toBe(8);
  });

  it('技能配置数据正确', () => {
    expect(SKILL_CONFIG[1001].name).toBe('普通攻击');
    expect(SKILL_CONFIG[1001].category).toBe(SkillCategory.ATTACK);
    expect(SKILL_CONFIG[1002].name).toBe('重击');
    expect(SKILL_CONFIG[2001].name).toBe('防御');
    expect(SKILL_CONFIG[2002].name).toBe('治疗');
  });

  it('技能配置包含必要字段', () => {
    for (const [id, skill] of Object.entries(SKILL_CONFIG)) {
      expect(skill.id).toBe(Number(id));
      expect(skill.name).toBeDefined();
      expect(skill.category).toBeDefined();
      expect(skill.cooldown).toBeGreaterThan(0);
      expect(skill.mpCost).toBeGreaterThanOrEqual(0);
      expect(skill.range).toBeGreaterThanOrEqual(0);
      expect(skill.targetType).toBeDefined();
      expect(skill.effectType).toBeDefined();
    }
  });
});