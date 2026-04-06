import Phaser, { Scene } from 'phaser';

interface OtherPlayer {
  body: Phaser.GameObjects.Graphics;
  nameText: Phaser.GameObjects.Text;
  x: number;
  y: number;
  mapId: number;
  nickName?: string;
  roleType?: number;
}

interface Portal {
  targetMapId: number;
  x: number;
  y: number;
  label: string;
}

// Portal definitions per map (positions within the 960x540 canvas, grid area: x:50-910, y:80-500)
const PORTALS_BY_MAP: Record<number, Portal[]> = {
  1001: [
    { targetMapId: 1002, x: 880, y: 400, label: "→ 竹林" },
    { targetMapId: 1003, x: 500, y: 500, label: "→ 山谷" },
  ],
  1002: [
    { targetMapId: 1001, x: 50, y: 350, label: "← 新手村" },
    { targetMapId: 1005, x: 850, y: 350, label: "→ 竞技场" },
  ],
  1003: [
    { targetMapId: 1001, x: 600, y: 80, label: "← 新手村" },
    { targetMapId: 1004, x: 800, y: 400, label: "→ 蛇影洞" },
  ],
  1004: [
    { targetMapId: 1003, x: 800, y: 300, label: "← 山谷" },
  ],
  1005: [
    { targetMapId: 1002, x: 50, y: 400, label: "← 竹林" },
  ],
};

// Map name lookup
const MAP_NAMES: Record<number, string> = {
  1001: "新手村", 1002: "竹林深处", 1003: "虎口山谷", 1004: "蛇影洞", 1005: "竞技场"
};

// Map background colors
const MAP_COLORS: Record<number, string> = {
  1001: '#1a2a1a', 1002: '#1a3a1a', 1003: '#2a2a1a', 1004: '#1a1a2a', 1005: '#2a1a1a'
};

/**
 * Main game scene — renders the player, map, and handles movement sync.
 */
export class GameScene extends Scene {
  private playerBody: Phaser.GameObjects.Graphics | null = null;
  private playerX = 480;
  private playerY = 300;
  private cursors: Phaser.Types.Input.Keyboard.CursorKeys | undefined;
  private statusText: Phaser.GameObjects.Text | null = null;
  private lastMoveTime = 0;
  private otherPlayers: Map<number, OtherPlayer> = new Map();
  private portalGroups: Map<number, { body: Phaser.GameObjects.Graphics; text: Phaser.GameObjects.Text }> = new Map();
  private currentMapId = 1001;
  private lastPortalSwitch = 0;
  private mapInfoText: Phaser.GameObjects.Text | null = null;

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
    this.cameras.main.setBackgroundColor(MAP_COLORS[this.currentMapId] || '#1a2a1a');

    // Player visual — red rectangle (placeholder)
    this.playerBody = this.add.graphics().fillStyle(0xff4444);
    this.drawPlayer();

    // Draw ground / grid
    this.drawGround();

    // Draw HUD
    this.drawHUD();

    // Draw portals
    this.drawPortals();

    // Keyboard input
    this.cursors = this.input.keyboard?.createCursorKeys();

    // Status text
    this.statusText = this.add.text(480, 30, '就绪 - 使用方向键移动', {
      fontSize: '14px',
      color: '#ffffff',
    }).setOrigin(0.5);

    // Map info text (bottom of screen)
    this.mapInfoText = this.add.text(480, 520, `地图: ${MAP_NAMES[this.currentMapId] || '未知'} (${this.currentMapId})`, {
      fontSize: '12px',
      color: '#666688',
    }).setOrigin(0.5);

    // Network listeners
    const network = this.game.registry.get('network');
    if (network) {
      // Player leave
      network.on('cmd:14003', (data: any) => {
        this.removeOtherPlayer(data.userId);
        this.statusText?.setText(`玩家 ${data.userId} 离开了地图`);
      });

      // Player list on map join / single player join
      network.on('cmd:14001', (data: any) => {
        if (data.players?.length > 0) {
          // batch player list (from enterGame response)
          for (const pData of data.players) {
            this.addOtherPlayer(pData);
          }
          this.statusText?.setText(`地图上有 ${data.players.length} 个其他玩家`);
        } else if (data.userId !== undefined) {
          // single player join (broadcast from another player entering)
          this.addOtherPlayer(data);
        }
      });

      // Other player moved
      network.on('cmd:1001', (data: any) => {
        if (data.userId !== undefined) {
          this.updateOtherPlayerPosition(data.userId, data.pos?.x, data.pos?.y, data.mapId, data.nickName);
        }
      });

      // Other player stood
      network.on('cmd:1002', (data: any) => {
        if (data.userId !== undefined) {
          this.updateOtherPlayerPosition(data.userId, data.pos?.x, data.pos?.y, data.mapId, data.nickName);
        }
      });

      // Other player jumped
      network.on('cmd:1003', (data: any) => {
        if (data.userId !== undefined) {
          this.updateOtherPlayerPosition(data.userId, data.pos?.x, data.pos?.y, undefined);
        }
      });

      // Other player used skill
      network.on('cmd:2004', (data: any) => {
        if (data.userId !== undefined) {
          console.log(`[GameScene] Player ${data.userId} used skill ${data.skillId}`);
        }
      });

      // Map switch response
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

    // Request map players list (after scene is ready with listeners registered)
    network.getMapPlayers();

    // Auto-send initial position
    this.time.delayedCall(500, () => {
      const playerData = this.game.registry.get('playerData');
      if (network && playerData) {
        network.move(playerData.mapId, playerData.pos?.x || 500, playerData.pos?.y || 300, 150, 1);
      }
    });
  }

  update(): void {
    if (!this.playerBody || !this.cursors) return;

    const speed = 3;
    let moved = false;

    if (this.cursors.left?.isDown) {
      this.playerX -= speed;
      moved = true;
    }
    if (this.cursors.right?.isDown) {
      this.playerX += speed;
      moved = true;
    }
    if (this.cursors.up?.isDown) {
      this.playerY -= speed;
      moved = true;
    }
    if (this.cursors.down?.isDown) {
      this.playerY += speed;
      moved = true;
    }

    if (moved) {
      this.playerBody.clear();
      this.playerBody.fillStyle(0xff4444);
      this.drawPlayer();

      const now = Date.now();
      if (now - this.lastMoveTime > 100) {
        this.lastMoveTime = now;
        const network = this.game.registry.get('network');
        if (network) {
          const playerData = this.game.registry.get('playerData');
          network.move(playerData?.mapId || 1001, this.playerX, this.playerY, 150, 1);
        }
      }
    }

    // Portal collision detection
    this.checkPortalCollision();

    this.statusText?.setText(`位置: (${Math.round(this.playerX)}, ${Math.round(this.playerY)})`);
  }

  // --- Other player management ---

  private addOtherPlayer(data: any): void {
    const userId = data.userId;
    if (this.otherPlayers.has(userId)) return; // already exists

    const x = data.pos?.x || 500;
    const y = data.pos?.y || 300;

    // Other player body — blue rectangle
    const body = this.add.graphics().fillStyle(0x4488ff);
    body.fillRect(x - 16, y - 24, 32, 48);
    body.fillStyle(0xffffff);
    body.fillRect(x - 8, y - 14, 6, 6);
    body.fillRect(x + 2, y - 14, 6, 6);

    // Name label above the player
    const name = data.nickName || `Player${userId}`;
    const nameText = this.add.text(x, y - 36, name, {
      fontSize: '11px',
      color: '#88ccff',
    }).setOrigin(0.5);

    this.otherPlayers.set(userId, { body, nameText, x, y, mapId: data.mapId || 0, nickName: data.nickName });
    this.statusText?.setText(`${name} 加入了地图`);
  }

  private updateOtherPlayerPosition(userId: number, x: number | undefined, y: number | undefined, mapId: number | undefined, nickName?: string): void {
    const player = this.otherPlayers.get(userId);
    if (!player) {
      // Player not yet created — create on first movement broadcast
      if (x !== undefined && y !== undefined) {
        this.addOtherPlayer({ userId, x, y, mapId, nickName, pos: { x, y } });
      }
      return;
    }

    if (x !== undefined) player.x = x;
    if (y !== undefined) player.y = y;
    if (mapId !== undefined) player.mapId = mapId;
    if (nickName) player.nickName = nickName;

    // Redraw at new position
    player.body.clear();
    player.body.fillStyle(0x4488ff);
    player.body.fillRect(player.x - 16, player.y - 24, 32, 48);
    player.body.fillStyle(0xffffff);
    player.body.fillRect(player.x - 8, player.y - 14, 6, 6);
    player.body.fillRect(player.x + 2, player.y - 14, 6, 6);

    player.nameText.setPosition(player.x, player.y - 36);
  }

  private removeOtherPlayer(userId: number): void {
    const player = this.otherPlayers.get(userId);
    if (player) {
      player.body.destroy();
      player.nameText.destroy();
      this.otherPlayers.delete(userId);
    }
  }

  // --- Drawing helpers ---

  private drawPlayer(): void {
    if (!this.playerBody) return;
    this.playerBody.fillRect(this.playerX - 16, this.playerY - 24, 32, 48);
    this.playerBody.fillStyle(0xffffff);
    this.playerBody.fillRect(this.playerX - 8, this.playerY - 14, 6, 6);
    this.playerBody.fillRect(this.playerX + 2, this.playerY - 14, 6, 6);
  }

  private drawGround(): void {
    const ground = this.add.graphics();
    ground.lineStyle(2, 0x336633);
    ground.strokeRect(50, 80, 860, 420);

    const grid = this.add.graphics();
    grid.lineStyle(1, 0x224422, 0.3);
    for (let x = 50; x <= 910; x += 40) {
      grid.lineBetween(x, 80, x, 500);
    }
    for (let y = 80; y <= 500; y += 40) {
      grid.lineBetween(50, y, 910, y);
    }
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
    const portals = PORTALS_BY_MAP[this.currentMapId] || [];
    this.portalGroups.clear();

    const mapName = this.game.registry.get('playerData')?.mapName;
    // Reset HUD on each map switch
    this.add.rectangle(0, 0, 0, 0, 0x000000).destroy();

    for (const portal of portals) {
      const body = this.add.graphics();
      // Portal circle — yellow, pulsing effect
      body.lineStyle(2, 0xffff00, 1);
      body.fillStyle(0xffff00, 0.2);
      body.fillCircle(portal.x, portal.y, 20);
      body.strokeCircle(portal.x, portal.y, 20);

      // Glow ring
      body.lineStyle(1, 0xffff00, 0.4);
      body.strokeCircle(portal.x, portal.y, 26);

      const text = this.add.text(portal.x, portal.y - 28, portal.label, {
        fontSize: '12px',
        color: '#ffff88',
      }).setOrigin(0.5);

      // Portal target map label below
      const targetInfo = this.add.text(portal.x, portal.y + 28, MAP_NAMES[portal.targetMapId] || '', {
        fontSize: '10px',
        color: '#aaaacc',
      }).setOrigin(0.5);

      this.portalGroups.set(portal.targetMapId, { body, text });
    }
  }

  private checkPortalCollision(): void {
    const portals = PORTALS_BY_MAP[this.currentMapId] || [];
    if (portals.length === 0) return;

    const now = Date.now();
    const cooldown = 1500;

    if (now - this.lastPortalSwitch < cooldown) return;

    for (const portal of portals) {
      const dx = this.playerX - portal.x;
      const dy = this.playerY - portal.y;
      const dist = Math.sqrt(dx * dx + dy * dy);

      // DEBUG: always log distance
      if (dist < 150) {
        console.log(`[Portal] Player(${this.playerX},${this.playerY}) -> Portal(${portal.x},${portal.y}) dist=${dist.toFixed(0)}`);
      }

      if (dist < 60) {
        console.log(`[Portal] TRIGGERED! dist=${dist.toFixed(0)}`);
        this.lastPortalSwitch = now;
        this.switchMap(portal.targetMapId, portal);
        break; // Only switch one portal at a time
      }
    }
  }

  private switchMap(targetMapId: number, portal: Portal): void {
    console.log('[Portal] switchMap called:', targetMapId, portal);
    const network = this.game.registry.get('network');
    if (!network) {
      console.warn('[Portal] network is null!');
      return;
    }
    console.log('[Portal] network found, mapId:', targetMapId, 'pos:', { x: portal.x, y: portal.y });

    this.statusText?.setText(`正在切换到 ${portal.label} ...`);
    network.mapSwitch(targetMapId, 0, { x: portal.x, y: portal.y });
    console.log('[Portal] mapSwitch sent');
  }

  private handleMapSwitchSuccess(data: any): void {
    // Update current map info
    this.currentMapId = data.mapId;
    const mapInfo = data.newMapData;

    // Reposition player to the server-confirmed spawn point
    if (data.position) {
      this.playerX = data.position.x;
      this.playerY = data.position.y;
      this.playerBody?.clear();
      this.playerBody?.fillStyle(0xff4444);
      this.drawPlayer();
    }

    // Update registry
    const playerData = this.game.registry.get('playerData');
    if (playerData) {
      playerData.mapId = data.mapId;
      playerData.mapName = data.mapName;
    }

    // Clear existing portals and other players
    for (const group of this.portalGroups.values()) {
      group.body.destroy();
      group.text.destroy();
    }
    this.portalGroups.clear();

    // Clear all existing other players
    for (const [id, player] of this.otherPlayers) {
      player.body.destroy();
      player.nameText.destroy();
    }
    this.otherPlayers.clear();

    // Update visuals for new map
    this.cameras.main.setBackgroundColor(MAP_COLORS[this.currentMapId] || '#1a2a1a');

    // Redraw portals for the new map
    this.drawPortals();

    // Update map info text
    this.mapInfoText?.setText(`地图: ${data.mapName || MAP_NAMES[this.currentMapId] || '未知'} (${this.currentMapId})`);

    // Request player list on the new map
    const network = this.game.registry.get('network');
    network?.getMapPlayers();

    this.statusText?.setText(`已到达 ${data.mapName}`);
    this.time.delayedCall(2000, () => {
      if (this.statusText) {
        this.statusText.setColor('#ffffff');
      }
    });
  }
}
