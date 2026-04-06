/**
 * Player animation/behavior states for the state machine.
 * DNF-style: flat XY plane, no gravity. Jump is an upward animation arc.
 */
export enum PlayerState {
  IDLE = 'idle',
  MOVE_LEFT = 'move_left',
  MOVE_RIGHT = 'move_right',
  MOVE_UP = 'move_up',
  MOVE_DOWN = 'move_down',
  JUMP = 'jump',
}

// Visual config per state (placeholder — swap with real animation frames later)
export const STATE_COLORS: Record<PlayerState, number> = {
  [PlayerState.IDLE]: 0xff4444,      // red
  [PlayerState.MOVE_LEFT]: 0xff8844,  // orange
  [PlayerState.MOVE_RIGHT]: 0xff8844, // orange
  [PlayerState.MOVE_UP]: 0x44aaff,    // blue
  [PlayerState.MOVE_DOWN]: 0x44aaff,  // blue
  [PlayerState.JUMP]: 0x44ff88,       // green
};
