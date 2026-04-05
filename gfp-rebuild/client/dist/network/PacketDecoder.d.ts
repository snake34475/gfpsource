export interface PacketHeader {
    length: number;
    commandId: number;
    userId?: number;
}
export interface DecodedPacket {
    header: PacketHeader;
    data: any;
    commandId: number;
}
export declare class PacketDecoder {
    static decode(buffer: ArrayBuffer): DecodedPacket;
    private static decodeBody;
    static decodeUserId(buffer: ArrayBuffer): number | null;
    static decodeCommandId(buffer: ArrayBuffer): number | null;
}
//# sourceMappingURL=PacketDecoder.d.ts.map