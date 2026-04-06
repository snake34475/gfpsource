import Phaser, { Scene } from 'phaser';
import { PlayerEntity } from '../entities/PlayerEntity';
import { OtherPlayerEntity } from '../entities/OtherPlayerEntity';
import { PlayerStateMachine } from '../systems/PlayerStateMachine';
import { Portal } from '../types/portal';
import { MAP_NAMES, MAP_COLORS, PORTALS_BY_MAP } from '../config/maps';
import { PlayerState } from '../types/animation';

/**
 * DNF-style game scene: flat XY plane, 4-directional movement, no gravity/platforms.
 * Handles local player, remote players, portals, and network sync.
 */
export class GameScene extends Scene {
  private player: PlayerEntity | null = null;
  private statusText: Phaser.GameObjects.Text | null = null;
  private otherPlayers: Map<number, OtherPlayerEntity> = new Map();
  private portalIndicators: Phaser.GameObjects.Graphics[] = [];
  private currentMapId = 1001;
  private lastPortalSwitch = 0;
  private mapInfoText: Phaser.GameObjects.Text | null = null;
  private groundGraphics: Phaser.GameObjects.Graphics | null = null;

  constructor() {
    super({ key: 'GameScene' });
  }

  init(data: any): void {
    const playerData = this.game.registry.get('playerData');
    if (playerData?.mapId) {
      this.currentMapId = playerData.mapId;
    }
    if (data?.mapId) {
      this.currentMapId = data.mapId;
    }
  }

  create(): void {
    this.cameras.main.backgroundColor = Phaser.Display.Color.ValueToColor(MAP_COLORS[this.currentMapId] || '#1a2a1a');

    // Draw ground surface
    this.drawGround();

    // Draw portals
    this.drawPortals();

    // Draw HUD
    this.drawHUD();

    // Status text
    this.statusText = this.add.text(480, 30, '方向键移动 · 空格跳跃 · 走到传送门切换地图', {
      fontSize: '13px',
      color: '#ffffff',
    }).setOrigin(0.5);

    // Map info
    this.mapInfoText = this.add.text(480, 520, `地图: ${MAP_NAMES[this.currentMapId] || '未知'} (${this.currentMapId})`, {
      fontSize: '12px',
      color: '#666688',
    }).setOrigin(0.5);

    // Create local player
    const spawnX = this.game.registry.get('playerData')?.pos?.x || 480;
    const spawnY = this.game.registry.get('playerData')?.pos?.y || 300;
    this.player = new PlayerEntity(this, spawnX, spawnY);
    this.player.setMapId(this.currentMapId);

    // Network listeners
    const network = this.game.registry.get('network');
    if (network) {
      network.on('cmd:14003', (data: any) => {
        this.removeOtherPlayer(data.userId);
        this.statusText?.setText(`玩家 ${data.userId} 离开了地图`);
      });

      network.on('cmd:14001', (data: any) => {
        if (data.players?.length > 0) {
          for (const pData of data.players) {
            this.addOtherPlayer(pData);
          }
          this.statusText?.setText(`地图上有 ${data.players.length} 个其他玩家`);
        } else if (data.userId !== undefined) {
          this.addOtherPlayer(data);
        }
      });

      network.on('cmd:1001', (data: any) => {
        if (data.userId !== undefined) {
          this.updateOtherPlayer(data.userId, data.pos?.x, data.pos?.y, data.mapId, data.nickName, 1001);
        }
      });

      network.on('cmd:1002', (data: any) => {
        if (data.userId !== undefined) {
          this.updateOtherPlayer(data.userId, data.pos?.x, data.pos?.y, data.mapId, data.nickName, 1002);
        }
      });

      network.on('cmd:1003', (data: any) => {
        if (data.userId !== undefined) {
          this.updateOtherPlayer(data.userId, data.pos?.x, data.pos?.y, undefined, data.nickName, 1003);
        }
      });

      network.on('cmd:2004', (data: any) => {
        if (data.userId !== undefined) {
          console.log(`[GameScene] Player ${data.userId} used skill ${data.skillId}`);
        }
      });

      network.on('cmd:14005', (data: any) => {
        if (data.result === 0) {
          this.handleMapSwitchSuccess(data);
        } else {
          this.statusText?.setText(`切换地图失败: ${data.error}`).setColor('#ff6666');
          this.time.delayedCall(2000, () => this.statusText?.setColor('#ffffff'));
        }
      });

      network.on('disconnect', () => {
        this.statusText?.setText('连接已断开!').setColor('#ff6666');
      });
    }

    network.getMapPlayers();
  }

  update(time: number, delta: number): void {
    if (this.player) {
      this.player.update(time);

      // Portal collision
      this.checkPortalCollision();

      const pos = this.player.getWorldPos();
      this.statusText?.setText(`地图: ${MAP_NAMES[this.currentMapId]} | 位置: (${Math.round(pos.x)}, ${Math.round(pos.y)})`);
    }

    // Smooth update remote players
    for (const other of this.otherPlayers.values()) {
      other.smoothUpdate(time, 0.15);
    }
  }

  // --- Other player management ---

  private addOtherPlayer(data: any): void {
    const userId = data.userId;
    if (this.otherPlayers.has(userId)) return;

    const x = data.pos?.x || 480;
    const y = data.pos?.y || 300;

    const entity = new OtherPlayerEntity(this, userId, x, y, data.nickName);
    this.otherPlayers.set(userId, entity);
    this.statusText?.setText(`${data.nickName || `Player${userId}`} 加入了地图`);
  }

  private updateOtherPlayer(userId: number, x: number | undefined, y: number | undefined, _mapId: number | undefined, nickName?: string, commandId?: number): void {
    let entity = this.otherPlayers.get(userId);
    if (!entity) {
      if (x !== undefined && y !== undefined) {
        entity = new OtherPlayerEntity(this, userId, x, y, nickName);
        this.otherPlayers.set(userId, entity);
      } else {
        return;
      }
    }

    if (x !== undefined && y !== undefined) {
      entity.setPosition(x, y);
    }

    if (commandId === 1003) {
      entity.onJumpStart(this.time.now);
    } else if (commandId !== undefined) {
      entity.setState(PlayerStateMachine.inferStateFromCommand(commandId));
    }
  }

  private removeOtherPlayer(userId: number): void {
    const entity = this.otherPlayers.get(userId);
    if (entity) {
      entity.destroy();
      this.otherPlayers.delete(userId);
    }
  }

  // --- Rendering ---

  private drawGround(): void {
    if (this.groundGraphics) this.groundGraphics.destroy();
    this.groundGraphics = this.add.graphics();

    // Ground plane (flat surface)
    this.groundGraphics.fillStyle(0x2a4a2a, 1);
    this.groundGraphics.fillRect(20, 80, 920, 420);

    // Grid lines for depth perception
    this.groundGraphics.lineStyle(1, 0x3a6a3a, 0.4);
    for (let y = 80; y <= 500; y += 40) {
      this.groundGraphics.lineBetween(20, y, 940, y);
    }
    for (let x = 20; x <= 940; x += 40) {
      this.groundGraphics.lineBetween(x, 80, x, 500);
    }

    // Ground border
    this.groundGraphics.lineStyle(2, 0x4a8a4a);
    this.groundGraphics.strokeRect(20, 80, 920, 420);

    // Depth label hint
    this.add.text(480, 95, '(前) ↑ Y 纵深 ↑ (后)', {
      fontSize: '10px',
      color: '#5a8a5a',
    }).setOrigin(0.5);
  }

  private drawHUD(): void {
    this.add.rectangle(480, 15, 960, 30, 0x000000, 0.6);
    this.add.text(20, 5, 'HP: 1000/1000', { fontSize: '13px', color: '#ff4444' });
    this.add.text(180, 5, 'MP: 500/500', { fontSize: '13px', color: '#4444ff' });

    const playerData = this.game.registry.get('playerData');
    if (playerData) {
      this.add.text(320, 5, `玩家: ${playerData.nickName || '未知'}`, { fontSize: '13px', color: '#ffcc00' });
      this.add.text(520, 5, `地图: ${playerData.mapName || '未知'}`, { fontSize: '13px', color: '#88cc88' });
    }
  }

  private drawPortals(): void {
    for (const g of this.portalIndicators) g.destroy();
    this.portalIndicators = [];

    const portals = PORTALS_BY_MAP[this.currentMapId] || [];

    for (const portal of portals) {
      const body = this.add.graphics();
      body.lineStyle(2, 0xffff00, 1);
      body.fillStyle(0xffff00, 0.2);
      body.fillCircle(portal.x, portal.y, 20);
      body.strokeCircle(portal.x, portal.y, 20);
      body.lineStyle(1, 0xffff00, 0.4);
      body.strokeCircle(portal.x, portal.y, 26);
      this.portalIndicators.push(body);

      this.add.text(portal.x, portal.y - 28, portal.label, {
        fontSize: '12px',
        color: '#ffff88',
      }).setOrigin(0.5);

      this.add.text(portal.x, portal.y + 28, MAP_NAMES[portal.targetMapId] || '', {
        fontSize: '10px',
        color: '#aaaacc',
      }).setOrigin(0.5);
    }
  }

  private checkPortalCollision(): void {
    if (!this.player) return;
    const portals = PORTALS_BY_MAP[this.currentMapId] || [];
    if (portals.length === 0) return;

    const now = Date.now();
    if (now - this.lastPortalSwitch < 1500) return;

    const pos = this.player.getWorldPos();

    for (const portal of portals) {
      const dx = pos.x - portal.x;
      const dy = pos.y - portal.y;
      const dist = Math.sqrt(dx * dx + dy * dy);

      if (dist < 40) {
        this.lastPortalSwitch = now;
        this.switchMap(portal.targetMapId, portal);
        break;
      }
    }
  }

  private switchMap(targetMapId: number, portal: Portal): void {
    const network = this.game.registry.get('network');
    if (!network) return;

    this.statusText?.setText(`正在切换到 ${portal.label} ...`);
    network.mapSwitch(targetMapId, 0, { x: portal.x, y: portal.y });
  }

  private handleMapSwitchSuccess(data: any): void {
    this.currentMapId = data.mapId;

    if (this.player && data.position) {
      this.player.reposition(data.position.x, data.position.y);
    }
    if (this.player) {
      this.player.setMapId(data.mapId);
    }

    const playerData = this.game.registry.get('playerData');
    if (playerData) {
      playerData.mapId = data.mapId;
      playerData.mapName = data.mapName;
    }

    // Clear portals and other players
    for (const g of this.portalIndicators) g.destroy();
    this.portalIndicators = [];
    for (const [_, entity] of this.otherPlayers) {
      entity.destroy();
    }
    this.otherPlayers.clear();

    // Redraw
    this.cameras.main.backgroundColor = Phaser.Display.Color.ValueToColor(MAP_COLORS[this.currentMapId] || '#1a2a1a');
    this.drawGround();
    this.drawPortals();
    this.mapInfoText?.setText(`地图: ${data.mapName || MAP_NAMES[this.currentMapId] || '未知'} (${this.currentMapId})`);

    const network = this.game.registry.get('network');
    network?.getMapPlayers();

    this.statusText?.setText(`已到达 ${data.mapName}`);
    this.time.delayedCall(2000, () => {
      if (this.statusText) this.statusText.setColor('#ffffff');
    });
  }
}
