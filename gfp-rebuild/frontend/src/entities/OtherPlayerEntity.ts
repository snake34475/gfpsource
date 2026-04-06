import Phaser from 'phaser';
import { PlayerState, STATE_COLORS } from '../types/animation';

/**
 * DNF-style remote player — position driven by network messages.
 * No physics, just visual display with smooth interpolation.
 * Jump is rendered as a visual arc.
 */
export class OtherPlayerEntity {
  public userId: number;
  private graphic: Phaser.GameObjects.Graphics;
  private nameText: Phaser.GameObjects.Text;
  private shadow: Phaser.GameObjects.Ellipse;
  private targetX: number;
  private targetY: number;
  private currentX: number;
  private currentY: number;
  private state: PlayerState = PlayerState.IDLE;
  private jumpZ = 0;
  private jumpStartTime = 0;
  private groundY = 400;

  constructor(scene: Phaser.Scene, userId: number, x: number, y: number, nickName?: string) {
    this.userId = userId;
    this.targetX = x;
    this.targetY = y;
    this.currentX = x;
    this.currentY = y;

    // Ground shadow
    this.shadow = scene.add.ellipse(x, this.groundY + 24, 28, 8, 0x000000, 0.3);
    this.shadow.setDepth(5);

    // Visual
    this.graphic = scene.add.graphics();
    this.graphic.setDepth(9);

    // Name
    const name = nickName || `Player${userId}`;
    this.nameText = scene.add.text(x, this.currentY - 40, name, {
      fontSize: '11px',
      color: '#88ccff',
    }).setOrigin(0.5);

    this.render(STATE_COLORS[this.state], 0);
  }

  setPosition(x: number, y: number): void {
    this.targetX = x;
    this.targetY = y;
  }

  setState(state: PlayerState): void {
    this.state = state;
  }

  /**
   * Smoothly interpolate position. Called every frame.
   */
  smoothUpdate(_time: number, lerpFactor: number = 0.15): void {
    const prevX = this.currentX;
    const prevY = this.currentY;
    this.currentX += (this.targetX - this.currentX) * lerpFactor;
    this.currentY += (this.targetY - this.currentY) * lerpFactor;

    // Jump arc for remote players
    this.jumpZ = 0;
    if (this.state === PlayerState.JUMP && this.jumpStartTime > 0) {
      const elapsed = _time - this.jumpStartTime;
      if (elapsed < 450) {
        const progress = elapsed / 450;
        this.jumpZ = -30 * 4 * progress * (1 - progress);
      } else {
        this.jumpStartTime = 0;
      }
    }
    if (this.state !== PlayerState.JUMP) {
      this.jumpStartTime = 0;
      this.jumpZ = 0;
    }

    const displayY = this.currentY + this.jumpZ;
    const color = STATE_COLORS[this.state];
    this.render(color, displayY);
  }

  onJumpStart(time: number): void {
    this.jumpStartTime = time;
    this.state = PlayerState.JUMP;
  }

  destroy(): void {
    this.graphic.destroy();
    this.nameText.destroy();
    this.shadow.destroy();
  }

  private render(color: number, displayY: number): void {
    const flip = this.state === PlayerState.MOVE_LEFT;

    // Shadow
    this.shadow.setPosition(this.currentX, this.groundY + 24);
    const shadowScale = Math.max(0.3, 1 + this.jumpZ / 60);
    this.shadow.setScale(shadowScale, 1);

    // Body
    this.graphic.clear();
    this.graphic.fillStyle(color, 1);
    this.graphic.fillRect(this.currentX - 16, displayY - 24, 32, 48);

    // Eyes
    this.graphic.fillStyle(0xffffff);
    const eyeOffsetMain = flip ? -14 : 6;
    const eyeOffsetSecondary = flip ? -6 : 14;
    this.graphic.fillRect(this.currentX + eyeOffsetMain - 4, displayY - 14, 6, 6);
    this.graphic.fillRect(this.currentX + eyeOffsetSecondary - 4, displayY - 14, 6, 6);

    // Name
    this.nameText.setPosition(this.currentX, displayY - 40);
  }
}
