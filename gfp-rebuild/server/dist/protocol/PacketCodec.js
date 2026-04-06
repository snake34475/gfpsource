"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PacketEncoder = exports.PacketDecoder = void 0;
class PacketDecoder {
    static decode(buffer) {
        const headerLength = buffer.readUInt32LE(0);
        const commandId = buffer.readUInt32LE(4);
        let data = {};
        let userId;
        if (headerLength > 4) {
            try {
                const bodyLength = Math.min(headerLength - 4, buffer.length - 8);
                if (bodyLength > 0) {
                    const body = buffer.slice(8, 8 + bodyLength);
                    data = this.decodeBody(commandId, body);
                    userId = this.extractUserId(commandId, body);
                }
            }
            catch (e) {
                console.warn("[PacketDecoder] Failed to decode body:", e);
            }
        }
        return {
            header: { length: headerLength, commandId },
            data,
            userId,
        };
    }
    static extractUserId(commandId, body) {
        return undefined;
    }
    static decodeBody(commandId, body) {
        // Try JSON first (most test clients and Phaser client send JSON body)
        if (body.length > 0 && body[0] === 0x7b) { // '{'
            return this.parseJsonBody(body);
        }
        // Fall back to binary decode for known commands
        try {
            return this._binaryDecode(commandId, body);
        }
        catch {
            return this.parseJsonBody(body);
        }
    }
    static ensure(body, offset, needed) {
        return offset + needed <= body.length;
    }
    static _binaryDecode(commandId, body) {
        switch (commandId) {
            case 1001: return this.decodeMove(body);
            case 1002: return this.decodeStand(body);
            case 1003: return this.decodeJump(body);
            case 1004: return this.decodePvpMove(body);
            case 2003: return this.decodeBruise(body);
            case 2004: return this.decodeSkill(body);
            case 2005: return this.decodeBuff(body);
            default: return {};
        }
    }
    static decodeMove(body) {
        const data = {};
        let o = 0;
        if (!this.ensure(body, o, 4))
            return data;
        data.mapId = body.readUInt32LE(o);
        o += 4;
        if (this.ensure(body, o, 8)) {
            data.pos = { x: body.readUInt32LE(o), y: body.readUInt32LE(o + 4) };
            o += 8;
        }
        if (this.ensure(body, o, 1)) {
            data.speed = body.readUInt8(o);
            o += 1;
        }
        if (this.ensure(body, o, 1)) {
            data.moveType = body.readUInt8(o);
        }
        return data;
    }
    static decodeStand(body) {
        const data = {};
        let o = 0;
        if (!this.ensure(body, o, 4))
            return data;
        data.mapId = body.readUInt32LE(o);
        o += 4;
        if (this.ensure(body, o, 8)) {
            data.pos = { x: body.readUInt32LE(o), y: body.readUInt32LE(o + 4) };
            o += 8;
        }
        if (this.ensure(body, o, 1)) {
            data.direction = body.readUInt8(o);
        }
        return data;
    }
    static decodeJump(body) {
        const data = {};
        if (this.ensure(body, 0, 8)) {
            data.pos = { x: body.readUInt32LE(0), y: body.readUInt32LE(4) };
        }
        return data;
    }
    static decodePvpMove(body) {
        const data = {};
        if (this.ensure(body, 0, 18)) {
            data.pos = { x: body.readUInt32LE(0), y: body.readUInt32LE(4) };
            data.mapId = body.readUInt32LE(8);
            data.speed = body.readUInt8(12);
            data.moveType = body.readUInt8(13);
            data.timestamp = body.readUInt16LE(14);
        }
        return data;
    }
    static decodeBruise(body) {
        if (!this.ensure(body, 0, 52))
            return this.parseJsonBody(body);
        const data = {};
        let o = 0;
        data.decHP = body.readInt32LE(o);
        o += 4;
        data.hp = body.readInt32LE(o);
        o += 4;
        data.atkerID = body.readUInt32LE(o);
        o += 4;
        data.userID = body.readUInt32LE(o);
        o += 4;
        data.crit = body.readUInt8(o) === 1;
        o += 1;
        data.critMultiple = body.readUInt8(o);
        o += 1;
        data.decType = body.readUInt8(o);
        o += 1;
        data.type = body.readUInt8(o);
        o += 1;
        data.hitCount = body.readUInt8(o);
        o += 1;
        data.breakFlag = body.readUInt8(o) === 1;
        o += 1;
        data.skillID = body.readUInt32LE(o);
        o += 4;
        data.skillLv = body.readUInt8(o);
        o += 1;
        data.runDuration = body.readFloatLE(o);
        o += 4;
        data.stiffDuration = body.readFloatLE(o);
        o += 4;
        data.pos = { x: body.readFloatLE(o), y: body.readFloatLE(o + 4) };
        return data;
    }
    static decodeSkill(body) {
        const data = {};
        if (this.ensure(body, 0, 40)) {
            data.skillId = body.readUInt32LE(0);
            data.skillLv = body.readUInt32LE(4);
            data.roleId = body.readUInt32LE(8);
            data.spriteType = body.readUInt32LE(12);
            data.pos = { x: body.readUInt32LE(16), y: body.readUInt32LE(20) };
            data.targetId = body.readUInt32LE(24);
            data.direction = body.readUInt32LE(28);
        }
        return data;
    }
    static decodeBuff(body) {
        const data = {};
        if (this.ensure(body, 0, 18)) {
            data.userId = body.readUInt32LE(0);
            data.keyId = body.readUInt16LE(4);
            data.buffId = body.readUInt32LE(6);
            data.add = body.readUInt8(10) === 1;
        }
        return data;
    }
    static parseJsonBody(body) {
        if (body.length === 0)
            return {};
        try {
            return JSON.parse(body.toString("utf8"));
        }
        catch {
            return { raw: body.toString("hex") };
        }
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
                if (value >= 0 && value <= 65535) {
                    const buf = Buffer.alloc(2);
                    buf.writeUInt16LE(value, 0);
                    return buf;
                }
                // Fallback to double for overflow values
                const buf = Buffer.alloc(8);
                buf.writeDoubleLE(value, 0);
                return buf;
            }
            else {
                const buf = Buffer.alloc(8);
                buf.writeDoubleLE(value, 0);
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