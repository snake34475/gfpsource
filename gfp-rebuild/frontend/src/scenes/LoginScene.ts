import { Scene } from 'phaser';

export class LoginScene extends Scene {
  constructor() {
    super({ key: 'LoginScene' });
  }

  create(): void {
    // Background
    this.cameras.main.setBackgroundColor('#0f0f23');

    // Title
    const title = this.add.text(480, 120, '功夫派', {
      fontSize: '64px',
      color: '#ffcc00',
      fontStyle: 'bold',
    }).setOrigin(0.5);

    const subtitle = this.add.text(480, 180, 'GFP Rebuild', {
      fontSize: '24px',
      color: '#8888aa',
    }).setOrigin(0.5);

    // Server address display
    this.add.text(480, 230, 'Server: ws://localhost:8080', {
      fontSize: '14px',
      color: '#555577',
    }).setOrigin(0.5);

    // Username input
    const usernameBg = this.add.rectangle(480, 290, 300, 40, 0x222244).setStrokeStyle(2, 0x444466);
    const usernamePrompt = this.add.text(340, 280, '用户名:', {
      fontSize: '16px',
      color: '#aaaaaa',
    });
    const usernameText = this.add.text(430, 280, 'test_user', {
      fontSize: '16px',
      color: '#ffffff',
    });

    // Password input
    const passwordBg = this.add.rectangle(480, 340, 300, 40, 0x222244).setStrokeStyle(2, 0x444466);
    const passwordPrompt = this.add.text(340, 330, '密  码:', {
      fontSize: '16px',
      color: '#aaaaaa',
    });
    const passwordText = this.add.text(430, 330, '123456', {
      fontSize: '16px',
      color: '#ffffff',
    });

    // Login button
    const loginBtn = this.add.rectangle(480, 420, 200, 50, 0x3366cc)
      .setInteractive({ useHandCursor: true })
      .on('pointerover', () => loginBtn.setFillStyle(0x4488ee))
      .on('pointerout', () => loginBtn.setFillStyle(0x3366cc))
      .on('pointerdown', () => this.startLogin());

    const loginLabel = this.add.text(480, 420, '登 录', {
      fontSize: '20px',
      color: '#ffffff',
      fontStyle: 'bold',
    }).setOrigin(0.5).setInteractive({ useHandCursor: true })
      .on('pointerdown', () => this.startLogin());

    // Status text
    const statusText = this.add.text(480, 480, '', {
      fontSize: '14px',
      color: '#ff6666',
    }).setOrigin(0.5);

    // Store references for login
    this.registry.set('username', 'test_user');

    // Listen for login response
    const network = this.game.registry.get('network');
    if (network) {
      network.on('cmd:10001', (data: any) => {
        if (data.result === 0) {
          statusText.setText('登录成功，正在选角...').setColor('#66ff66');
          network.selectRole(1);
        } else {
          statusText.setText('登录失败: ' + (data.error || '未知错误')).setColor('#ff6666');
        }
      });

      network.on('cmd:10005', (data: any) => {
        if (data.result === 0) {
          statusText.setText('选角成功，进入游戏...').setColor('#66ff66');
          network.enterGame();
        }
      });

      network.on('cmd:10006', (data: any) => {
        console.log('[LoginScene] EnterGame response:', data);
        if (data.result === 0) {
          this.game.registry.set('playerData', data);
          statusText.setText('进入游戏成功!').setColor('#66ff66');
          this.time.delayedCall(500, () => {
            this.scene.start('GameScene');
          });
        }
      });

      network.on('disconnect', () => {
        statusText.setText('服务器连接已断开').setColor('#ff6666');
      });
    }
  }

  private startLogin(): void {
    const network = this.game.registry.get('network') as any;
    if (!network) {
      console.error('[LoginScene] Network not initialized');
      return;
    }

    // Try to connect if not connected
    if (!network.connected) {
      network.connect().then(() => {
        console.log('[LoginScene] Connected, sending login');
        network.login(this.registry.get('username') || 'test_user', '123456');
      }).catch((err: Error) => {
        console.error('[LoginScene] Connection failed:', err);
      });
    } else {
      network.login(this.registry.get('username') || 'test_user', '123456');
    }
  }
}
