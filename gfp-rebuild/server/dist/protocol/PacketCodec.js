"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PacketEncoder = exports.PacketDecoder = void 0;
class PacketDecoder {
    static decode(buffer) {
        const view = new DataView(buffer.buffer, buffer.byteOffset, buffer.length);
        const length = view.getUint32(0, true);
        const commandId = view.getUint32(4, true);
        let data = {};
        let userId;
        if (length > 4) {
            try {
                const bodyLength = Math.min(length - 4, buffer.length - 8);
                if (bodyLength > 0) {
                    const dataView = new DataView(buffer.buffer, buffer.byteOffset + 8, bodyLength);
                    data = this.decodeBody(commandId, dataView);
                    userId = this.extractUserId(commandId, dataView);
                }
            }
            catch (e) {
                console.warn("[PacketDecoder] Failed to decode body:", e);
            }
        }
        return {
            header: { length, commandId },
            data,
            userId,
        };
    }
    static extractUserId(commandId, view) {
        return undefined;
    }
    static decodeBody(commandId, view) {
        const data = {};
        let offset = 0;
        const viewLength = view.byteLength;
        try {
            switch (commandId) {
                case 1001: // MOVE: mapId(4) + pos(8) + speed(1) + moveType(1) = 14 bytes
                    if (offset + 4 <= viewLength) {
                        data.mapId = view.getUint32(offset, true);
                        offset += 4;
                    }
                    if (offset + 8 <= viewLength) {
                        data.pos = { x: view.getUint32(offset, true), y: view.getUint32(offset + 4, true) };
                        offset += 8;
                    }
                    if (offset + 1 <= viewLength) {
                        data.speed = view.getUint8(offset);
                        offset += 1;
                    }
                    if (offset + 1 <= viewLength) {
                        data.moveType = view.getUint8(offset);
                    }
                    break;
                case 1002: // STAND: mapId(4) + pos(8) + direction(1) = 13 bytes
                    if (offset + 4 <= viewLength) {
                        data.mapId = view.getUint32(offset, true);
                        offset += 4;
                    }
                    if (offset + 8 <= viewLength) {
                        data.pos = { x: view.getUint32(offset, true), y: view.getUint32(offset + 4, true) };
                        offset += 8;
                    }
                    if (offset + 1 <= viewLength) {
                        data.direction = view.getUint8(offset);
                    }
                    break;
                case 1003: // JUMP: pos(8) = 8 bytes
                    if (offset + 8 <= viewLength) {
                        data.pos = { x: view.getUint32(offset, true), y: view.getUint32(offset + 4, true) };
                    }
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
                default:
                    data.raw = Buffer.from(view.buffer).toString("hex");
                    break;
            }
        }
        catch (e) {
            console.warn("[PacketDecoder] Error decoding command", commandId, e);
        }
        return data;
    }
}
exports.PacketDecoder = PacketDecoder;
class PacketEncoder {
    static encode(commandId, data = {}) {
        const body = this.encodeBody(commandId, data);
        const length = 4 + body.length;
        const buffer = Buffer.alloc(4 + body.length);
        buffer.writeUInt32LE(length, 0);
        buffer.writeUInt32LE(commandId, 4);
        body.copy(buffer, 8);
        return buffer;
    }
    static encodeBody(commandId, data) {
        const chunks = [];
        if (Array.isArray(data)) {
            for (const item of data) {
                chunks.push(this.encodeValue(item));
            }
        }
        else if (typeof data === "object" && data !== null) {
            for (const key of Object.keys(data)) {
                chunks.push(this.encodeValue(data[key]));
            }
        }
        return Buffer.concat(chunks);
    }
    static encodeValue(value) {
        if (value === null || value === undefined) {
            return Buffer.alloc(0);
        }
        else if (typeof value === "number") {
            if (Number.isInteger(value)) {
                const buf = Buffer.alloc(4);
                buf.writeInt32LE(value, 0);
                return buf;
            }
            else {
                const buf = Buffer.alloc(4);
                buf.writeFloatLE(value, 0);
                return buf;
            }
        }
        else if (typeof value === "string") {
            const strBuf = Buffer.from(value, "utf8");
            const lenBuf = Buffer.alloc(2);
            lenBuf.writeUInt16LE(strBuf.length, 0);
            return Buffer.concat([lenBuf, strBuf]);
        }
        else if (typeof value === "boolean") {
            const buf = Buffer.alloc(1);
            buf.writeUInt8(value ? 1 : 0, 0);
            return buf;
        }
        else if (typeof value === "object") {
            if (value.hasOwnProperty("x") && value.hasOwnProperty("y")) {
                const xBuf = Buffer.alloc(4);
                xBuf.writeUInt32LE(value.x || 0, 0);
                const yBuf = Buffer.alloc(4);
                yBuf.writeUInt32LE(value.y || 0, 0);
                return Buffer.concat([xBuf, yBuf]);
            }
            else {
                const chunks = [];
                for (const key of Object.keys(value)) {
                    chunks.push(this.encodeValue(value[key]));
                }
                return Buffer.concat(chunks);
            }
        }
        return Buffer.alloc(0);
    }
    static encodeMove(userId, mapId, x, y, speed, moveType) {
        return this.encode(1001, [userId, mapId, x, y, speed, moveType]);
    }
    static encodeStand(userId, mapId, x, y, direction) {
        return this.encode(1002, [userId, mapId, x, y, direction]);
    }
    static encodeBruise(decHP, hp, atkerID, userID, crit, critMultiple, decType, type, hitCount, breakFlag, skillID, skillLv, runDuration, stiffDuration, posX, posY) {
        return this.encode(2003, {
            decHP, hp, atkerID, userID,
            crit: crit ? 1 : 0,
            critMultiple, decType, type, hitCount,
            breakFlag: breakFlag ? 1 : 0,
            skillID, skillLv, runDuration, stiffDuration,
            posX, posY
        });
    }
}
exports.PacketEncoder = PacketEncoder;
//# sourceMappingURL=PacketCodec.js.map