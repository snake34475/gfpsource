import Phaser from 'phaser';
import { PlayerStateMachine } from '../systems/PlayerStateMachine';
import { JumpAnimation } from '../systems/JumpAnimation';
import { PlayerState, STATE_COLORS } from '../types/animation';
import { GameNetwork } from '../managers/GameNetwork';

/**
 * DNF-style local player: 4-directional movement on flat plane, no gravity.
 * Jump is a visual arc animation, not physics.
 */
export class PlayerEntity {
  private graphic: Phaser.GameObjects.Graphics;
  private shadow: Phaser.GameObjects.Ellipse;
  private stateMachine: PlayerStateMachine = new PlayerStateMachine();
  private jumpAnim: JumpAnimation = new JumpAnimation();
  private cursors: Phaser.Types.Input.Keyboard.CursorKeys | undefined;
  private spaceKey: Phaser.Input.Keyboard.Key | undefined;
  private lastNetworkTime = 0;
  private networkInterval = 100;
  private network: GameNetwork | null = null;
  private mapId = 1001;
  private x: number;
  private y: number;
  private groundY = 400; // default ground reference

  constructor(scene: Phaser.Scene, x: number, y: number) {
    this.x = x;
    this.y = y;

    // Shadow on the ground (stays on ground, follows player)
    this.shadow = scene.add.ellipse(x, this.groundY + 24, 28, 8, 0x000000, 0.3);
    this.shadow.setDepth(5);

    // Visual rendering
    this.graphic = scene.add.graphics();
    this.graphic.setDepth(10);

    // Input
    this.cursors = scene.input.keyboard?.createCursorKeys();
    this.spaceKey = scene.input.keyboard?.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);

    // Network
    this.network = scene.game.registry.get('network') as GameNetwork | null;
    const playerData = scene.game.registry.get('playerData');
    if (playerData?.mapId) {
      this.mapId = playerData.mapId;
    }

    this.render(Phaser.Math.DegToRad(0), 0, PlayerState.IDLE);
  }

  update(time: number): void {
    let moveX = 0;
    let moveY = 0;

    if (this.cursors?.left?.isDown) moveX -= 1;
    if (this.cursors?.right?.isDown) moveX += 1;
    if (this.cursors?.up?.isDown) moveY -= 1;
    if (this.cursors?.down?.isDown) moveY += 1;

    // Jump on space
    const wantsJump = (this.spaceKey?.isDown ?? false) && !this.jumpAnim.isActive();

    if (wantsJump) {
      this.jumpAnim.start(time);
    }

    // Movement speed (pixels per frame)
    const speed = 3;

    // Normalize diagonal movement
    if (moveX !== 0 && moveY !== 0) {
      const norm = 1 / Math.SQRT2;
      moveX *= norm;
      moveY *= norm;
    }

    this.x += moveX * speed;
    this.y += moveY * speed;

    // Clamp to canvas bounds
    this.x = Phaser.Math.Clamp(this.x, 30, 930);
    this.y = Phaser.Math.Clamp(this.y, 100, 500);

    // Jump Z offset
    const jumpZ = this.jumpAnim.getZOffset(time);

    // Determine direction for facing
    let angle = 0;
    if (moveX < 0) angle = Math.PI;
    else if (moveX > 0) angle = 0;

    // State machine
    const state = this.stateMachine.update(moveX, moveY, wantsJump, time);

    // Render
    this.render(angle, jumpZ, state);

    // Send to server
    const now = time;
    if ((moveX !== 0 || moveY !== 0) && now - this.lastNetworkTime > this.networkInterval) {
      this.lastNetworkTime = now;
      this.network?.move(this.mapId, this.x, this.y, 150, 1);
    }
  }

  getWorldPos(): { x: number; y: number } {
    return { x: this.x, y: this.y };
  }

  getState(): PlayerState {
    return this.stateMachine.getState();
  }

  getMapId(): number {
    return this.mapId;
  }

  setMapId(mapId: number): void {
    this.mapId = mapId;
  }

  reposition(x: number, y: number): void {
    this.x = x;
    this.y = y;
    this.jumpAnim.stop();
  }

  destroy(): void {
    this.graphic.destroy();
    this.shadow.destroy();
  }

  // --- Rendering ---

  private render(angle: number, jumpZ: number, state: PlayerState): void {
    const color = STATE_COLORS[state];
    const flip = angle === Math.PI;
    const displayY = this.y + jumpZ; // jump lifts character up on screen

    // Update shadow — follows player X/Y on the ground plane, shrinks during jump
    this.shadow.setPosition(this.x, this.y + 24);
    const shadowScale = Math.max(0.3, 1 + jumpZ / 60);
    this.shadow.setScale(shadowScale, 1);

    this.graphic.clear();

    // Body
    this.graphic.fillStyle(color, 1);
    this.graphic.fillRect(this.x - 16, displayY - 24, 32, 48);

    // Eyes — direction indicator
    this.graphic.fillStyle(0xffffff);
    const eyeOffsetMain = flip ? -14 : 6;
    const eyeOffsetSecondary = flip ? -6 : 14;
    this.graphic.fillRect(this.x + eyeOffsetMain - 4, displayY - 14, 6, 6);
    this.graphic.fillRect(this.x + eyeOffsetSecondary - 4, displayY - 14, 6, 6);
  }
}
