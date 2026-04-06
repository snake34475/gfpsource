/**
 * DNF-style map boundary definition.
 * No platforms, just a flat XY ground plane with edge walls.
 */
export interface MapBoundary {
  x: number;       // center X
  y: number;       // center Y
  width: number;
  height: number;
}

export function getMapBoundary(mapId: number): { walkable: MapBoundary } {
  // Shared walkable region for all maps (960x540 canvas)
  return {
    walkable: { x: 480, y: 270, width: 960, height: 540 },
  };
}

/**
 * Simple ground line for visual rendering.
 * Y position where characters stand.
 */
export const GROUND_Y = 400;
