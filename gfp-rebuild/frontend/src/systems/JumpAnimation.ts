/**
 * Jump arc animation for DNF-style movement.
 * No gravity physics — jump is a visual arc that returns to ground.
 */
export class JumpAnimation {
  private startTime = 0;
  private duration = 400; // ms
  private peakHeight = 30; // pixels above ground (positive = up in screen coords)
  private active = false;

  start(time: number): void {
    this.startTime = time;
    this.active = true;
  }

  /**
   * Returns the Z offset for the current frame (positive = up).
   * Returns 0 when jump is complete.
   */
  getZOffset(time: number): number {
    if (!this.active) return 0;

    const elapsed = time - this.startTime;
    const progress = Math.min(elapsed / this.duration, 1);

    if (progress >= 1) {
      this.active = false;
      return 0;
    }

    // Parabolic arc: 0→peak→0, negative = up in Phaser screen coords
    return -this.peakHeight * 4 * progress * (1 - progress);
  }

  isActive(): boolean {
    return this.active;
  }

  stop(): void {
    this.active = false;
  }
}
