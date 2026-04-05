export interface LoginInfo {
  session: string;
  roleTime: number;
  serverVersion: string;
  clientType: number;
  isAdult: number;
  fromeGameID: string;
  tad: string;
}

export interface RoleInfo {
  roleId: number;
  roleName: string;
  roleType: number;
  level: number;
  hp: number;
  mp: number;
  exp: number;
  mapId: number;
  pos: { x: number; y: number };
  direction: number;
  outfit: number;
  weapon: number;
  wing: number;
  title: number;
}

export interface UserInfo {
  userId: number;
  userName: string;
  roles: RoleInfo[];
  vipLevel: number;
  gold: number;
  yuanBao: number;
}

export interface LoginResponse {
  userId: number;
  userName: string;
  roles: RoleInfo[];
}

export interface RoleListResponse {
  roles: RoleInfo[];
}