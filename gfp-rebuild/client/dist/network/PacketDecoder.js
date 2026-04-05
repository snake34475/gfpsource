"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PacketDecoder = void 0;
class PacketDecoder {
    static decode(buffer) {
        const view = new DataView(buffer);
        const length = view.getUint32(0, true);
        const commandId = view.getUint32(4, true);
        const dataView = new DataView(buffer, 8, length - 4);
        const data = this.decodeBody(commandId, dataView);
        return {
            header: {
                length,
                commandId,
            },
            data,
            commandId,
        };
    }
    static decodeBody(commandId, view) {
        const data = {};
        let offset = 0;
        switch (commandId) {
            case 1001: // MOVE
                data.mapId = view.getUint32(offset, true);
                offset += 4;
                data.pos = {
                    x: view.getUint32(offset, true),
                    y: view.getUint32(offset + 4, true),
                };
                offset += 8;
                data.speed = view.getUint8(offset);
                offset += 1;
                data.moveType = view.getUint8(offset);
                break;
            case 1002: // STAND
                data.mapId = view.getUint32(offset, true);
                offset += 4;
                data.pos = {
                    x: view.getUint32(offset, true),
                    y: view.getUint32(offset + 4, true),
                };
                offset += 8;
                data.direction = view.getUint8(offset);
                break;
            case 1003: // JUMP
                data.pos = {
                    x: view.getUint32(offset, true),
                    y: view.getUint32(offset + 4, true),
                };
                break;
            case 1004: // PVP_MOVE
                data.pos = {
                    x: view.getUint32(offset, true),
                    y: view.getUint32(offset + 4, true),
                };
                offset += 8;
                data.mapId = view.getUint32(offset, true);
                offset += 4;
                data.speed = view.getUint8(offset);
                offset += 1;
                data.moveType = view.getUint8(offset);
                offset += 1;
                data.timestamp = view.getUint16(offset, true);
                break;
            case 2003: // ACTION_BRUISE
                data.decHP = view.getInt32(offset, true);
                offset += 4;
                data.hp = view.getInt32(offset, true);
                offset += 4;
                data.atkerID = view.getUint32(offset, true);
                offset += 4;
                data.userID = view.getUint32(offset, true);
                offset += 4;
                data.crit = view.getUint8(offset) === 1;
                offset += 1;
                data.critMultiple = view.getUint8(offset);
                offset += 1;
                data.decType = view.getUint8(offset);
                offset += 1;
                data.type = view.getUint8(offset);
                offset += 1;
                data.hitCount = view.getUint8(offset);
                offset += 1;
                data.breakFlag = view.getUint8(offset) === 1;
                offset += 1;
                data.skillID = view.getUint32(offset, true);
                offset += 4;
                data.skillLv = view.getUint8(offset);
                offset += 1;
                data.runDuration = view.getFloat32(offset, true);
                offset += 4;
                data.stiffDuration = view.getFloat32(offset, true);
                offset += 4;
                data.pos = {
                    x: view.getFloat32(offset, true),
                    y: view.getFloat32(offset + 4, true),
                };
                break;
            case 2004: // ACTION_SKILL
                data.skillId = view.getUint32(offset, true);
                offset += 4;
                data.skillLv = view.getUint32(offset, true);
                offset += 4;
                data.roleId = view.getUint32(offset, true);
                offset += 4;
                data.spriteType = view.getUint32(offset, true);
                offset += 4;
                data.pos = {
                    x: view.getUint32(offset, true),
                    y: view.getUint32(offset + 4, true),
                };
                offset += 8;
                data.targetId = view.getUint32(offset, true);
                offset += 4;
                data.direction = view.getUint32(offset, true);
                break;
            case 2005: // BUFF_STATE
                data.userId = view.getUint32(offset, true);
                offset += 4;
                data.keyId = view.getUint16(offset, true);
                offset += 2;
                data.buffId = view.getUint32(offset, true);
                offset += 4;
                data.add = view.getUint8(offset) === 1;
                break;
            case 3001: // ITEM_PICKUP
                const count = view.getUint32(offset, true);
                offset += 4;
                data.items = [];
                for (let i = 0; i < count; i++) {
                    const success = view.getUint8(offset) === 1;
                    offset += 1;
                    data.items.push({
                        success,
                        itemId: success ? view.getUint32(offset, true) : view.getUint32(offset, true),
                        count: success ? view.getUint32(offset + 4, true) : 0,
                        unknown: success ? view.getUint32(offset + 8, true) : 0,
                    });
                    offset += success ? 12 : 4;
                }
                break;
            default:
                data.raw = new Uint8Array(view.buffer);
                break;
        }
        return data;
    }
    static decodeUserId(buffer) {
        try {
            const view = new DataView(buffer);
            if (view.byteLength >= 12) {
                return view.getUint32(8, true);
            }
            return null;
        }
        catch {
            return null;
        }
    }
    static decodeCommandId(buffer) {
        try {
            const view = new DataView(buffer);
            if (view.byteLength >= 8) {
                return view.getUint32(4, true);
            }
            return null;
        }
        catch {
            return null;
        }
    }
}
exports.PacketDecoder = PacketDecoder;
//# sourceMappingURL=PacketDecoder.js.map