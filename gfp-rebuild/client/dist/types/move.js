"use strict";
// 移动相关类型定义
Object.defineProperty(exports, "__esModule", { value: true });
exports.PlayerState = exports.MoveType = void 0;
// 移动类型枚举
var MoveType;
(function (MoveType) {
    MoveType[MoveType["WALK"] = 1] = "WALK";
    MoveType[MoveType["RUN"] = 2] = "RUN";
    MoveType[MoveType["SPRINT"] = 3] = "SPRINT";
    MoveType[MoveType["SWIM"] = 4] = "SWIM";
    MoveType[MoveType["FLY"] = 5] = "FLY";
})(MoveType || (exports.MoveType = MoveType = {}));
// 玩家状态
var PlayerState;
(function (PlayerState) {
    PlayerState[PlayerState["IDLE"] = 0] = "IDLE";
    PlayerState[PlayerState["MOVE"] = 1] = "MOVE";
    PlayerState[PlayerState["JUMP"] = 2] = "JUMP";
    PlayerState[PlayerState["ATTACK"] = 3] = "ATTACK";
    PlayerState[PlayerState["SKILL"] = 4] = "SKILL";
    PlayerState[PlayerState["DEAD"] = 5] = "DEAD";
})(PlayerState || (exports.PlayerState = PlayerState = {}));
//# sourceMappingURL=move.js.map