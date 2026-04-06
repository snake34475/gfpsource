import { Scene } from 'phaser';

/**
 * Map scene - handles map transition display and shows map info.
 * Currently a placeholder for future map loading.
 */
export class MapScene extends Scene {
  private infoText: Phaser.GameObjects.Text | null = null;

  constructor() {
    super({ key: 'MapScene' });
  }

  create(): void {
    this.cameras.main.setBackgroundColor('#1a1a2e');

    this.add.text(480, 100, '地图切换', {
      fontSize: '36px',
      color: '#ffcc00',
      fontStyle: 'bold',
    }).setOrigin(0.5);

    this.infoText = this.add.text(480, 200, '加载中...', {
      fontSize: '18px',
      color: '#aaaacc',
    }).setOrigin(0.5);

    // Back button
    const backBtn = this.add.rectangle(480, 400, 160, 40, 0x444466)
      .setInteractive({ useHandCursor: true })
      .on('pointerdown', () => this.scene.start('GameScene'));

    this.add.text(480, 400, '返回游戏', {
      fontSize: '16px',
      color: '#ffffff',
    }).setOrigin(0.5).setInteractive({ useHandCursor: true })
      .on('pointerdown', () => this.scene.start('GameScene'));

    // Listen for map switch response
    const network = this.game.registry.get('network') as any;
    if (network) {
      network.on('cmd:14005', (data: any) => {
        if (this.infoText) {
          if (data.result === 0) {
            this.infoText.setText(
              `地图 ${data.mapId} - ${data.mapName}\n` +
              `尺寸: ${data.newMapData?.width}x${data.newMapData?.height}\n` +
              `出生点: (${data.position?.x}, ${data.position?.y})`
            ).setColor('#66ff66');

            // Auto return to game after 2s
            this.time.delayedCall(2000, () => {
              this.scene.start('GameScene');
            });
          } else {
            this.infoText?.setText(`切换失败: ${data.error || '未知错误'}`).setColor('#ff6666');
          }
        }
      });
    }
  }
}
