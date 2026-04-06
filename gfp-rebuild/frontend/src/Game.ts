import Phaser, { AUTO, Scale } from 'phaser';
import { LoginScene } from './scenes/LoginScene';
import { GameScene } from './scenes/GameScene';
import { MapScene } from './scenes/MapScene';

const config: Phaser.Types.Core.GameConfig = {
  type: AUTO,
  width: 960,
  height: 540,
  parent: 'game-container',
  backgroundColor: '#1a1a2e',
  scale: {
    mode: Scale.FIT,
    autoCenter: Phaser.Scale.CENTER_BOTH,
  },
  scene: [LoginScene, GameScene, MapScene],
};

export const game = new Phaser.Game(config);
