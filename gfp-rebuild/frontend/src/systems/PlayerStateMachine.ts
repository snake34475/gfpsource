import { PlayerState } from '../types/animation';

/**
 * DNF-style player state machine.
 * Flat XY plane: X = horizontal, Y = depth (forward/backward on ground).
 * Jump is a visual arc animation, not physics. No gravity, no platforms.
 */
export class PlayerStateMachine {
  private state: PlayerState = PlayerState.IDLE;
  private jumpStateTime = 0;

  update(moveX: number, moveY: number, wantsJump: boolean, time: number): PlayerState {
    const isMoving = moveX !== 0 || moveY !== 0;
    const currentlyJumping = this.state === PlayerState.JUMP;

    // If wants jump while idle/moving, enter JUMP state
    if (wantsJump && !currentlyJumping) {
      this.jumpStateTime = time;
      this.state = PlayerState.JUMP;
      return this.state;
    }

    // While jumping, stay in JUMP until animation finishes (~450ms)
    if (currentlyJumping && time - this.jumpStateTime < 450) {
      return this.state;
    }

    // Jump finished, fall through to normal state
    if (currentlyJumping && time - this.jumpStateTime >= 450) {
      // Will exit JUMP below
    }

    // Determine current movement state
    if (!isMoving) {
      this.state = PlayerState.IDLE;
    } else if (moveY < 0) {
      this.state = PlayerState.MOVE_UP;
    } else if (moveY > 0) {
      this.state = PlayerState.MOVE_DOWN;
    } else if (moveX < 0) {
      this.state = PlayerState.MOVE_LEFT;
    } else if (moveX > 0) {
      this.state = PlayerState.MOVE_RIGHT;
    }

    return this.state;
  }

  getState(): PlayerState {
    return this.state;
  }

  forceState(state: PlayerState): void {
    this.state = state;
  }

  /**
   * Infer state from network broadcast type (for remote players).
   */
  static inferStateFromCommand(commandId: number): PlayerState {
    switch (commandId) {
      case 1001: return PlayerState.MOVE_RIGHT;
      case 1004: return PlayerState.MOVE_RIGHT;
      case 1002: return PlayerState.IDLE;
      case 1003: return PlayerState.JUMP;
      default: return PlayerState.IDLE;
    }
  }
}
