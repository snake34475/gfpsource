export interface Position {
  x: number;
  y: number;
}

export interface BruiseInfo {
  decHP: number;
  hp: number;
  atkerID: number;
  userID: number;
  crit: boolean;
  critMultiple: number;
  decType: number;
  type: number;
  hitCount: number;
  breakFlag: boolean;
  skillID: number;
  skillLv: number;
  runDuration: number;
  stiffDuration: number;
  pos: Position;
  weaponEnchantedType?: number;
  roleID?: number;
}

export interface MoveInfo {
  userId: number;
  mapId: number;
  pos: Position;
  speed: number;
  moveType: number;
}

export interface StandInfo {
  userId: number;
  mapId: number;
  pos: Position;
  direction: number;
}

export interface JumpInfo {
  userId: number;
  pos: Position;
}

export interface SkillInfo {
  userId: number;
  skillId: number;
  skillLv: number;
  roleId: number;
  spriteType: number;
  pos: Position;
  targetId: number;
  direction: number;
}

export interface BuffInfo {
  userId: number;
  keyId: number;
  buffId: number;
  add: boolean;
}

export interface ItemPickupInfo {
  userId: number;
  items: Array<{
    success: boolean;
    itemId: number;
    count: number;
    unknown?: number;
  }>;
}

export interface FightInviteInfo {
  userId: number;
  inviterId: number;
  inviterName: string;
  stageId: number;
  difficult: number;
}

export interface FightReadyInfo {
  mapId: number;
  stageId: number;
  difficult: number;
  users: Array<{
    userId: number;
    pos: Position;
    hp: number;
    mp: number;
  }>;
}

export interface UserInfo {
  userID: number;
  nickName: string;
  roleType: number;
  level: number;
  mapID: number;
  pos: Position;
  hp: number;
  mp: number;
}