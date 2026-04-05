"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PacketEncoder = void 0;
const CommandID_1 = require("./CommandID");
class PacketEncoder {
    static encode(commandId, data = []) {
        const chunks = [];
        const header = new DataView(new ArrayBuffer(8));
        header.setUint32(0, commandId, true);
        const lengthPlaceholder = 4;
        chunks.push(new Uint8Array(header.buffer.slice(0, 4)));
        const bodyData = this.encodeBody(commandId, data);
        chunks.push(bodyData);
        const totalData = this.concatUint8Arrays(chunks);
        const length = totalData.length;
        const finalPacket = new DataView(new ArrayBuffer(4 + length));
        finalPacket.setUint32(0, length, true);
        for (let i = 0; i < length; i++) {
            finalPacket.setUint8(4 + i, totalData[i]);
        }
        return finalPacket.buffer;
    }
    static encodeBody(commandId, data) {
        const chunks = [];
        for (const item of data) {
            const chunk = this.encodeValue(item);
            chunks.push(chunk);
        }
        return this.concatUint8Arrays(chunks);
    }
    static encodeValue(value) {
        if (typeof value === "number") {
            if (Number.isInteger(value)) {
                if (value >= 0) {
                    if (value <= 255) {
                        const buf = new ArrayBuffer(1);
                        const view = new DataView(buf);
                        view.setUint8(0, value);
                        return new Uint8Array(buf);
                    }
                    else if (value <= 65535) {
                        const buf = new ArrayBuffer(2);
                        const view = new DataView(buf);
                        view.setUint16(0, value, true);
                        return new Uint8Array(buf);
                    }
                    else {
                        const buf = new ArrayBuffer(4);
                        const view = new DataView(buf);
                        view.setUint32(0, value, true);
                        return new Uint8Array(buf);
                    }
                }
                else {
                    const buf = new ArrayBuffer(4);
                    const view = new DataView(buf);
                    view.setInt32(0, value, true);
                    return new Uint8Array(buf);
                }
            }
            else {
                const buf = new ArrayBuffer(4);
                const view = new DataView(buf);
                view.setFloat32(0, value, true);
                return new Uint8Array(buf);
            }
        }
        else if (typeof value === "string") {
            const encoder = new TextEncoder();
            const strBytes = encoder.encode(value);
            const lenBuf = new ArrayBuffer(2);
            const lengthView = new DataView(lenBuf);
            lengthView.setUint16(0, strBytes.length, true);
            const result = new Uint8Array(2 + strBytes.length);
            result.set(new Uint8Array(lengthView.buffer), 0);
            result.set(strBytes, 2);
            return result;
        }
        else if (typeof value === "boolean") {
            const buf = new ArrayBuffer(1);
            const view = new DataView(buf);
            view.setUint8(0, value ? 1 : 0);
            return new Uint8Array(buf);
        }
        else if (Array.isArray(value)) {
            const lenBuf = new ArrayBuffer(4);
            const lengthView = new DataView(lenBuf);
            lengthView.setUint32(0, value.length, true);
            const chunks = [new Uint8Array(lengthView.buffer)];
            for (const item of value) {
                chunks.push(this.encodeValue(item));
            }
            return this.concatUint8Arrays(chunks);
        }
        else if (typeof value === "object" && value !== null) {
            const chunks = [];
            for (const key of Object.keys(value)) {
                chunks.push(this.encodeValue(value[key]));
            }
            return this.concatUint8Arrays(chunks);
        }
        return new Uint8Array(0);
    }
    static concatUint8Arrays(arrays) {
        const totalLength = arrays.reduce((sum, arr) => sum + arr.length, 0);
        const result = new Uint8Array(totalLength);
        let offset = 0;
        for (const arr of arrays) {
            result.set(arr, offset);
            offset += arr.length;
        }
        return result;
    }
    static encodeMove(mapId, x, y, speed, moveType) {
        return this.encode(CommandID_1.CommandID.MOVE, [mapId, x, y, speed, moveType]);
    }
    static encodeStand(mapId, x, y, direction) {
        return this.encode(CommandID_1.CommandID.STAND, [mapId, x, y, direction]);
    }
    static encodeJump(x, y) {
        return this.encode(CommandID_1.CommandID.JUMP, [x, y]);
    }
    static encodeSkill(skillId, skillLv, x, y, targetId) {
        return this.encode(CommandID_1.CommandID.ACTION_SKILL, [skillId, skillLv, x, y, targetId]);
    }
}
exports.PacketEncoder = PacketEncoder;
//# sourceMappingURL=PacketEncoder.js.map