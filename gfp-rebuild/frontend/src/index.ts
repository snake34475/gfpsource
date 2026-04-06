import { game } from './Game';
import { GameNetwork } from './managers/GameNetwork';

// Create network and store in registry
const network = new GameNetwork('ws://localhost:8080');
game.registry.set('network', network);

// Auto-connect on game load
network.connect().then(() => {
  console.log('[App] Network connected');
}).catch((err) => {
  console.warn('[App] Network connection failed, will retry on login:', err);
});

export { network };
