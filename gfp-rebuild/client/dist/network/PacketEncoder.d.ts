export type { PacketHeader } from "./PacketDecoder";
export declare class PacketEncoder {
    static encode(commandId: number, data?: any[]): ArrayBuffer;
    private static encodeBody;
    private static encodeValue;
    private static concatUint8Arrays;
    static encodeMove(mapId: number, x: number, y: number, speed: number, moveType: number): ArrayBuffer;
    static encodeStand(mapId: number, x: number, y: number, direction: number): ArrayBuffer;
    static encodeJump(x: number, y: number): ArrayBuffer;
    static encodeSkill(skillId: number, skillLv: number, x: number, y: number, targetId: number): ArrayBuffer;
}
//# sourceMappingURL=PacketEncoder.d.ts.map