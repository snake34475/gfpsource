// 服务端类型定义
import WebSocket from "ws";

export interface Position {
  x: number;
  y: number;
}

export interface Player {
  id: number;
  ws: WebSocket;
  mapId: number;
  pos: Position;
  speed: number;
  moveType: number;
  direction: number;
  nickName: string;
  roleType: number;
  level: number;
  hp: number;
  mp: number;
  lastUpdate: number;
}

export interface Client {
  ws: WebSocket;
  userId: number;
  actorId: number;
  player?: Player;
}

export interface GameState {
  players: Map<number, Player>;
  nextPlayerId: number;
}