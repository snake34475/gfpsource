// 移动相关类型定义

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

// 移动类型枚举
export enum MoveType {
  WALK = 1,
  RUN = 2,
  SPRINT = 3,
  SWIM = 4,
  FLY = 5,
}

// 玩家状态
export enum PlayerState {
  IDLE = 0,
  MOVE = 1,
  JUMP = 2,
  ATTACK = 3,
  SKILL = 4,
  DEAD = 5,
}

// 移动验证结果
export interface PositionValidationResult {
  valid: boolean;
  clampedX?: number;
  clampedY?: number;
  reason?: string;
}

// 移动历史记录（用于回放或同步）
export interface MoveHistoryEntry {
  playerId: number;
  timestamp: number;
  pos: Position;
  moveType: number;
}

// 移动同步数据（用于网络传输）
export interface MoveSyncData {
  playerId: number;
  mapId: number;
  pos: Position;
  speed: number;
  moveType: MoveType;
  timestamp: number;
  state: PlayerState;
}

// 移动事件（用于日志/统计）
export interface MoveEvent {
  playerId: number;
  eventType: 'start' | 'stop' | 'change_direction' | 'speed_change';
  timestamp: number;
  pos: Position;
  details?: Record<string, any>;
}