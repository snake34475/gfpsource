export interface Position {
    x: number;
    y: number;
}
export interface MoveData {
    mapId: number;
    pos: Position;
    speed: number;
    moveType: number;
}
export interface StandData {
    mapId: number;
    pos: Position;
    direction: number;
}
export interface JumpData {
    pos: Position;
}
export interface PvpMoveData {
    mapId: number;
    pos: Position;
    speed: number;
    moveType: number;
    timestamp: number;
}
export declare enum MoveType {
    WALK = 1,
    RUN = 2,
    SPRINT = 3,
    SWIM = 4,
    FLY = 5
}
export declare enum PlayerState {
    IDLE = 0,
    MOVE = 1,
    JUMP = 2,
    ATTACK = 3,
    SKILL = 4,
    DEAD = 5
}
export interface PositionValidationResult {
    valid: boolean;
    clampedX?: number;
    clampedY?: number;
    reason?: string;
}
export interface MoveHistoryEntry {
    playerId: number;
    timestamp: number;
    pos: Position;
    moveType: number;
}
export interface MoveSyncData {
    playerId: number;
    mapId: number;
    pos: Position;
    speed: number;
    moveType: MoveType;
    timestamp: number;
    state: PlayerState;
}
export interface MoveEvent {
    playerId: number;
    eventType: 'start' | 'stop' | 'change_direction' | 'speed_change';
    timestamp: number;
    pos: Position;
    details?: Record<string, any>;
}
//# sourceMappingURL=move.d.ts.map