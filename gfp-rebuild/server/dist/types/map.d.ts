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
    teleportType?: number;
    position?: {
        x: number;
        y: number;
    };
}
export interface MapSwitchResponse {
    result: number;
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
export declare const MAP_CONFIG: Record<number, MapInfo>;
export declare const DEFAULT_SPAWN_POINTS: Record<number, Position>;
//# sourceMappingURL=map.d.ts.map