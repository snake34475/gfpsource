"use strict";
// 技能相关类型定义
Object.defineProperty(exports, "__esModule", { value: true });
exports.SKILL_CONFIG = exports.EffectType = exports.TargetType = exports.SkillCategory = void 0;
var SkillCategory;
(function (SkillCategory) {
    SkillCategory[SkillCategory["ATTACK"] = 1] = "ATTACK";
    SkillCategory[SkillCategory["BUFF"] = 2] = "BUFF";
    SkillCategory[SkillCategory["DEBUFF"] = 3] = "DEBUFF";
    SkillCategory[SkillCategory["HEAL"] = 4] = "HEAL";
    SkillCategory[SkillCategory["SUMMON"] = 5] = "SUMMON";
    SkillCategory[SkillCategory["PASSIVE"] = 6] = "PASSIVE";
    SkillCategory[SkillCategory["SPECIAL"] = 7] = "SPECIAL";
})(SkillCategory || (exports.SkillCategory = SkillCategory = {}));
var TargetType;
(function (TargetType) {
    TargetType[TargetType["SELF"] = 0] = "SELF";
    TargetType[TargetType["ENEMY"] = 1] = "ENEMY";
    TargetType[TargetType["ALLY"] = 2] = "ALLY";
    TargetType[TargetType["GROUND"] = 3] = "GROUND";
    TargetType[TargetType["ANY"] = 4] = "ANY";
})(TargetType || (exports.TargetType = TargetType = {}));
var EffectType;
(function (EffectType) {
    EffectType[EffectType["DAMAGE"] = 1] = "DAMAGE";
    EffectType[EffectType["HEAL"] = 2] = "HEAL";
    EffectType[EffectType["BUFF_ADD"] = 3] = "BUFF_ADD";
    EffectType[EffectType["BUFF_REMOVE"] = 4] = "BUFF_REMOVE";
    EffectType[EffectType["DISPLACE"] = 5] = "DISPLACE";
    EffectType[EffectType["STUN"] = 6] = "STUN";
    EffectType[EffectType["SLOW"] = 7] = "SLOW";
    EffectType[EffectType["KNOCKBACK"] = 8] = "KNOCKBACK";
})(EffectType || (exports.EffectType = EffectType = {}));
// 技能配置
exports.SKILL_CONFIG = {
    1001: { id: 1001, name: "普通攻击", category: SkillCategory.ATTACK, cooldown: 500, mpCost: 0, range: 100, targetType: TargetType.ENEMY, effectType: EffectType.DAMAGE },
    1002: { id: 1002, name: "重击", category: SkillCategory.ATTACK, cooldown: 1500, mpCost: 20, range: 150, targetType: TargetType.ENEMY, effectType: EffectType.DAMAGE },
    1003: { id: 1003, name: "旋风斩", category: SkillCategory.ATTACK, cooldown: 3000, mpCost: 50, range: 200, targetType: TargetType.GROUND, effectType: EffectType.DAMAGE },
    2001: { id: 2001, name: "防御", category: SkillCategory.BUFF, cooldown: 5000, mpCost: 30, range: 0, targetType: TargetType.SELF, effectType: EffectType.BUFF_ADD },
    2002: { id: 2002, name: "治疗", category: SkillCategory.HEAL, cooldown: 8000, mpCost: 40, range: 300, targetType: TargetType.ALLY, effectType: EffectType.HEAL },
};
//# sourceMappingURL=skill.js.map