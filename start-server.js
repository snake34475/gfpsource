const { spawn } = require('child_process');
const server = spawn('node', ['gfp-rebuild/server/dist/index.js'], {
  detached: true,
  stdio: 'ignore'
});
server.unref();
console.log('Server started in background');
setTimeout(() => process.exit(0), 1000);