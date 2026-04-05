export interface PacketHeader {
    length: number;
    commandId: number;
}
export interface DecodedPacket {
    header: PacketHeader;
    data: any;
    userId?: number;
}
export declare class PacketDecoder {
    static decode(buffer: Buffer): DecodedPacket;
    private static extractUserId;
    private static decodeBody;
}
export declare class PacketEncoder {
    static encode(commandId: number, data?: any): Buffer;
    private static encodeBody;
    private static encodeValue;
    static encodeMove(userId: number, mapId: number, x: number, y: number, speed: number, moveType: number): Buffer;
    static encodeStand(userId: number, mapId: number, x: number, y: number, direction: number): Buffer;
    static encodeBruise(decHP: number, hp: number, atkerID: number, userID: number, crit: boolean, critMultiple: number, decType: number, type: number, hitCount: number, breakFlag: boolean, skillID: number, skillLv: number, runDuration: number, stiffDuration: number, posX: number, posY: number): Buffer;
}
//# sourceMappingURL=PacketCodec.d.ts.map