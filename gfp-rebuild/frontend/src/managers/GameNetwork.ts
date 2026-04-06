/**
 * Simple event emitter (browser-compatible, no Node.js dependency)
 */
type Listener = (...args: any[]) => void;

/**
 * Wraps the WebSocket connection to GFP server.
 * Handles binary packet encoding/decoding and dispatches events by command ID.
 */
export class GameNetwork {
  private ws: WebSocket | null = null;
  private url: string;
  private listeners: Map<string, Listener[]> = new Map();

  constructor(url: string) {
    this.url = url;
  }

  connect(): Promise<void> {
    return new Promise((resolve, reject) => {
      this.ws = new WebSocket(this.url);
      this.ws.binaryType = 'arraybuffer';

      this.ws.onopen = () => {
        console.log('[Network] Connected to', this.url);
        resolve();
      };

      this.ws.onclose = () => {
        console.log('[Network] Disconnected');
        this.emit('disconnect');
        this.ws = null;
      };

      this.ws.onerror = (err) => {
        console.error('[Network] Error:', err);
        reject(err);
      };

      this.ws.onmessage = (event) => {
        this.handleMessage(event.data);
      };
    });
  }

  disconnect(): void {
    if (this.ws) {
      this.ws.close();
      this.ws = null;
    }
  }

  send(commandId: number, data: any): void {
    if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
      console.warn('[Network] Not connected, cannot send CMD=' + commandId);
      return;
    }
    const packet = this.encodePacket(commandId, data);
    this.ws.send(packet);
    console.log(`[Network] >>> CMD=${commandId} ${JSON.stringify(data)}`);
  }

  on(event: string, listener: Listener): void {
    const list = this.listeners.get(event) || [];
    list.push(listener);
    this.listeners.set(event, list);
  }

  off(event: string, listener?: Listener): void {
    if (!listener) {
      this.listeners.delete(event);
      return;
    }
    const list = this.listeners.get(event) || [];
    const idx = list.indexOf(listener);
    if (idx >= 0) list.splice(idx, 1);
  }

  private emit(event: string, ...args: any[]): void {
    const list = this.listeners.get(event) || [];
    for (const fn of list) {
      fn(...args);
    }
  }

  private handleMessage(rawData: ArrayBuffer): void {
    const buffer = new Uint8Array(rawData);
    const view = new DataView(rawData);
    const totalLen = view.getUint32(0, true);
    const commandId = view.getUint32(4, true);
    const bodyBuf = buffer.slice(8);

    let data: any;
    if (bodyBuf.length > 0 && bodyBuf[0] === 0x7b) {
      // JSON body
      try {
        data = JSON.parse(new TextDecoder().decode(bodyBuf));
      } catch {
        data = { _raw: bodyBuf };
      }
    } else {
      data = { _raw: bodyBuf };
    }

    console.log(`[Network] <<< CMD=${commandId} ${JSON.stringify(data)}`);
    this.emit(`cmd:${commandId}`, data);
    this.emit('any', { commandId, data });
  }

  // --- Application-level helpers ---

  login(username: string, password: string): void {
    this.send(10001, { username, password });
  }

  selectRole(actorId: number): void {
    this.send(10005, { actorId });
  }

  enterGame(): void {
    this.send(10006, {});
  }

  move(mapId: number, x: number, y: number, speed: number, moveType: number): void {
    this.send(1001, { mapId, pos: { x, y }, speed, moveType });
  }

  stand(mapId: number, x: number, y: number, direction: number): void {
    this.send(1002, { mapId, pos: { x, y }, direction });
  }

  jump(x: number, y: number): void {
    this.send(1003, { pos: { x, y } });
  }

  /**
   * Request list of players on current map (call after GameScene loads)
   */
  getMapPlayers(): void {
    this.send(10007, {});
  }

  mapSwitch(targetMapId: number, teleportType?: number, position?: { x: number; y: number }): void {
    this.send(14005, { targetMapId, teleportType, position });
  }

  get connected(): boolean {
    return this.ws !== null && this.ws.readyState === WebSocket.OPEN;
  }

  // --- Encode helper ---

  private encodePacket(commandId: number, data: any): ArrayBuffer {
    const body = new TextEncoder().encode(JSON.stringify(data));
    const bodyLen = body.length;
    const packet = new ArrayBuffer(8 + bodyLen);
    const view = new DataView(packet);
    view.setUint32(0, 4 + bodyLen, true);
    view.setUint32(4, commandId, true);
    new Uint8Array(packet).set(body, 8);
    return packet;
  }
}
