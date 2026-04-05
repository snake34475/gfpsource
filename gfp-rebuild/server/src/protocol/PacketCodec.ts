export interface PacketHeader {
  length: number;
  commandId: number;
}

export interface DecodedPacket {
  header: PacketHeader;
  data: any;
  userId?: number;
}

export class PacketDecoder {
  static decode(buffer: Buffer): DecodedPacket {
    const view = new DataView(buffer.buffer, buffer.byteOffset, buffer.length);
    const length = view.getUint32(0, true);
    const commandId = view.getUint32(4, true);

    let data: any = {};
    let userId: number | undefined;

    if (length > 4) {
      try {
        const dataView = new DataView(buffer.buffer, buffer.byteOffset + 8, length - 4);
        data = this.decodeBody(commandId, dataView);
        userId = this.extractUserId(commandId, dataView);
      } catch (e) {
        console.warn("[PacketDecoder] Failed to decode body:", e);
      }
    }

    return {
      header: { length, commandId },
      data,
      userId,
    };
  }

  private static extractUserId(commandId: number, view: DataView): number | undefined {
    return undefined;
  }

  private static decodeBody(commandId: number, view: DataView): any {
    const data: any = {};
    let offset = 0;

    try {
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

        default:
          data.raw = Buffer.from(view.buffer).toString("hex");
          break;
      }
    } catch (e) {
      console.warn("[PacketDecoder] Error decoding command", commandId, e);
    }

    return data;
  }
}

export class PacketEncoder {
  static encode(commandId: number, data: any = {}): Buffer {
    const body = this.encodeBody(commandId, data);
    const length = 4 + body.length;
    
    const buffer = Buffer.alloc(4 + body.length);
    buffer.writeUInt32LE(length, 0);
    buffer.writeUInt32LE(commandId, 4);
    body.copy(buffer, 8);
    
    return buffer;
  }

  private static encodeBody(commandId: number, data: any): Buffer {
    const chunks: Buffer[] = [];

    if (Array.isArray(data)) {
      for (const item of data) {
        chunks.push(this.encodeValue(item));
      }
    } else if (typeof data === "object" && data !== null) {
      for (const key of Object.keys(data)) {
        chunks.push(this.encodeValue(data[key]));
      }
    }

    return Buffer.concat(chunks);
  }

  private static encodeValue(value: any): Buffer {
    if (value === null || value === undefined) {
      return Buffer.alloc(0);
    } else if (typeof value === "number") {
      if (Number.isInteger(value)) {
        if (value >= 0) {
          if (value <= 255) {
            const buf = Buffer.alloc(1);
            buf.writeUInt8(value, 0);
            return buf;
          } else if (value <= 65535) {
            const buf = Buffer.alloc(2);
            buf.writeUInt16LE(value, 0);
            return buf;
          } else {
            const buf = Buffer.alloc(4);
            buf.writeUInt32LE(value, 0);
            return buf;
          }
        } else {
          const buf = Buffer.alloc(4);
          buf.writeInt32LE(value, 0);
          return buf;
        }
      } else {
        const buf = Buffer.alloc(4);
        buf.writeFloatLE(value, 0);
        return buf;
      }
    } else if (typeof value === "string") {
      const strBuf = Buffer.from(value, "utf8");
      const lenBuf = Buffer.alloc(2);
      lenBuf.writeUInt16LE(strBuf.length, 0);
      return Buffer.concat([lenBuf, strBuf]);
    } else if (typeof value === "boolean") {
      const buf = Buffer.alloc(1);
      buf.writeUInt8(value ? 1 : 0, 0);
      return buf;
    } else if (typeof value === "object") {
      if (value.hasOwnProperty("x") && value.hasOwnProperty("y")) {
        const xBuf = Buffer.alloc(4);
        xBuf.writeUInt32LE(value.x || 0, 0);
        const yBuf = Buffer.alloc(4);
        yBuf.writeUInt32LE(value.y || 0, 0);
        return Buffer.concat([xBuf, yBuf]);
      } else {
        const chunks: Buffer[] = [];
        for (const key of Object.keys(value)) {
          chunks.push(this.encodeValue(value[key]));
        }
        return Buffer.concat(chunks);
      }
    }

    return Buffer.alloc(0);
  }

  static encodeMove(userId: number, mapId: number, x: number, y: number, speed: number, moveType: number): Buffer {
    return this.encode(1001, [userId, mapId, x, y, speed, moveType]);
  }

  static encodeStand(userId: number, mapId: number, x: number, y: number, direction: number): Buffer {
    return this.encode(1002, [userId, mapId, x, y, direction]);
  }

  static encodeBruise(decHP: number, hp: number, atkerID: number, userID: number, crit: boolean, critMultiple: number, decType: number, type: number, hitCount: number, breakFlag: boolean, skillID: number, skillLv: number, runDuration: number, stiffDuration: number, posX: number, posY: number): Buffer {
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