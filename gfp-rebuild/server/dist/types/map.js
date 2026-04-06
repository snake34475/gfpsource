"use strict";
// 地图相关类型定义
Object.defineProperty(exports, "__esModule", { value: true });
exports.DEFAULT_SPAWN_POINTS = exports.MAP_CONFIG = void 0;
// 地图配置（静态数据）
exports.MAP_CONFIG = {
    1001: { mapId: 1001, mapName: "新手村", width: 2000, height: 1500, requiredLevel: 1 },
    1002: { mapId: 1002, mapName: "竹林深处", width: 2500, height: 2000, requiredLevel: 1 },
    1003: { mapId: 1003, mapName: "虎口山谷", width: 3000, height: 2500, requiredLevel: 1 },
    1004: { mapId: 1004, mapName: "蛇影洞", width: 1800, height: 1200, requiredLevel: 1, isDungeon: true },
    1005: { mapId: 1005, mapName: "竞技场", width: 1500, height: 1500, isPVP: true },
};
// 默认出生点（坐标需在客户端可视范围内，画布网格区域: x:50-910, y:80-500）
exports.DEFAULT_SPAWN_POINTS = {
    1001: { x: 500, y: 300 },
    1002: { x: 600, y: 300 },
    1003: { x: 700, y: 350 },
    1004: { x: 400, y: 280 },
    1005: { x: 750, y: 350 },
};
//# sourceMappingURL=map.js.map