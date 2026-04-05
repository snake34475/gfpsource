// 地图相关类型定义

export interface MapInfo {
  mapId: number;
  mapName: string;
  width: number;
  height: number;
  bgMusic?: string;
  isPVP?: boolean;
  isDungeon?: boolean;
  requiredLevel?: number;
  limitTime?: number;
}

export interface MapSwitchRequest {
  targetMapId: number;
  teleportType?: number; // 0=walk, 1=teleport, 2=transition
  position?: {
    x: number;
    y: number;
  };
}

export interface MapSwitchResponse {
  result: number; // 0=success, other=error code
  mapId: number;
  mapName?: string;
  position?: {
    x: number;
    y: number;
  };
  newMapData?: {
    width: number;
    height: number;
    objects: MapObject[];
  };
}

export interface MapObject {
  id: number;
  type: 'npc' | 'monster' | 'portal' | 'item' | 'trigger';
  x: number;
  y: number;
  data?: any;
}

export interface MapPlayerInfo {
  userId: number;
  nickName: string;
  pos: Position;
  direction: number;
  roleType: number;
  hp: number;
  mp: number;
  level: number;
}

export interface Position {
  x: number;
  y: number;
}

// 地图配置（静态数据）
export const MAP_CONFIG: Record<number, MapInfo> = {
  1001: { mapId: 1001, mapName: "新手村", width: 2000, height: 1500, requiredLevel: 1 },
  1002: { mapId: 1002, mapName: "竹林深处", width: 2500, height: 2000, requiredLevel: 5 },
  1003: { mapId: 1003, mapName: "虎口山谷", width: 3000, height: 2500, requiredLevel: 10 },
  1004: { mapId: 1004, mapName: "蛇影洞", width: 1800, height: 1200, requiredLevel: 15, isDungeon: true },
  1005: { mapId: 1005, mapName: "竞技场", width: 1500, height: 1500, isPVP: true },
};

// 默认出生点
export const DEFAULT_SPAWN_POINTS: Record<number, Position> = {
  1001: { x: 500, y: 800 },
  1002: { x: 600, y: 900 },
  1003: { x: 700, y: 1000 },
  1004: { x: 400, y: 600 },
  1005: { x: 750, y: 750 },
};