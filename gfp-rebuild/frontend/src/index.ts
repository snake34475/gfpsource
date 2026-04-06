import { game } from './Game';
import { GameNetwork } from './managers/GameNetwork';

// WebSocket server URL — can be overridden via import.meta.env (set in .env or vite.config.ts)
const WS_URL = import.meta.env.VITE_WS_SERVER || 'ws://localhost:8080';

// Create network and store in registry
const network = new GameNetwork(WS_URL);
game.registry.set('network', network);

// Auto-connect on game load
network.connect().then(() => {
  console.log('[App] Network connected');
}).catch((err) => {
  console.warn('[App] Network connection failed, will retry on login:', err);
});

export { network };
