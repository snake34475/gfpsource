import { Portal } from '../types/portal';

export const PORTALS_BY_MAP: Record<number, Portal[]> = {
  1001: [
    { targetMapId: 1002, x: 880, y: 400, label: "→ 竹林" },
    { targetMapId: 1003, x: 500, y: 500, label: "→ 山谷" },
  ],
  1002: [
    { targetMapId: 1001, x: 50, y: 350, label: "← 新手村" },
    { targetMapId: 1005, x: 850, y: 350, label: "→ 竞技场" },
  ],
  1003: [
    { targetMapId: 1001, x: 600, y: 80, label: "← 新手村" },
    { targetMapId: 1004, x: 800, y: 400, label: "→ 蛇影洞" },
  ],
  1004: [
    { targetMapId: 1003, x: 800, y: 300, label: "← 山谷" },
  ],
  1005: [
    { targetMapId: 1002, x: 50, y: 400, label: "← 竹林" },
  ],
};

export const MAP_NAMES: Record<number, string> = {
  1001: "新手村", 1002: "竹林深处", 1003: "虎口山谷", 1004: "蛇影洞", 1005: "竞技场"
};

export const MAP_COLORS: Record<number, string> = {
  1001: '#1a2a1a', 1002: '#1a3a1a', 1003: '#2a2a1a', 1004: '#1a1a2a', 1005: '#2a1a1a'
};
