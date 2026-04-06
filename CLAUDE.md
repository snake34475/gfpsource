# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the source code for **GFP (KungFuPai / 功夫派)**, a 2D side-scroller game originally built entirely in ActionScript 3 with a thin-client architecture. This repo contains both the **original AS3 game** and an early-stage **TypeScript rebuild project** using WebSocket.

## Repository Structure

```
gfpsource/
├── clientappdll/            # Original AS3 game client (1,500+ .as files)
│   └── src/com/gfp/app/     # Main game: MainEntry.as, managers, maps, fights, UI
├── clientcoredll/           # Original AS3 core library (encryption, Crossbridge C bridge)
├── xml/                     # Server config (Server.xml, dll.xml bean registry)
├── gfp-rebuild/             # TypeScript rebuild project (WebSocket)
│   ├── client/              # Protocol layer: SocketClient, PacketEncoder/Decoder, CommandID enum
│   │   └── src/             # network/, types/, index.ts; tests/ with vitest
│   ├── server/              # Mock game server: GFPServer with modular handlers
│   │   └── src/             # handlers/, protocol/, types/, index.ts
│   ├── frontend/            # Phaser 3 frontend (TypeScript + Vite)
│   │   └── src/             # Game.ts, scenes/, managers/, index.ts
│   └── docs/                # Architecture, plan, checklist, verify-guide (Chinese)
├── 源码架构分析文档.md        # Architecture analysis document (Chinese)
└── 复刻技术文档.md          # Rebuild technical document (Chinese)
```

## Architecture

### Original Game (AS3)
- **Thin client**: All damage calculations, drop logic, and validation are server-side
- **Protocol**: TCP binary socket (port 1863), `ByteArray` serialization routed by `CommandID` constants
- **Command/listener pattern**: `xml/dll.xml` registers 60+ Bean classes (command listeners)
- **Manager pattern**: Centralized managers (`FightManager`, `MapManager`, etc.)
- **Factory pattern for maps**: 521 separate `MapProcess_XXXXXX.as` classes, one per map

### Rebuild Project (TypeScript)
- **Protocol**: WebSocket with binary packet format `[length: 4 bytes LE][commandId: 4 bytes LE][body: variable]`
- **Server**: `gfp-rebuild/server/src/index.ts` — `GFPServer` class with in-memory player state; handlers extracted into modular files under `handlers/`
- **Client library**: `gfp-rebuild/client/src/` — `SocketClient` (EventEmitter with reconnection), `CommandID.ts` enum (250+ commands), typed data structures
- **Frontend**: `gfp-rebuild/frontend/src/` — Phaser 3 game engine with `GameNetwork.ts` for WebSocket communication, scenes for Login/Game/Map
- **Server types**: `server/src/types/` — shared interfaces (Player, Client, GameState, Position) and map-related types (MapInfo, MAP_CONFIG, spawn points)

### Frontend Architecture
- Game scenes: `LoginScene` (login/role selection) → `GameScene` (main gameplay, portals, multiplayer sync) → `MapScene` (map switch display)
- `GameNetwork.ts` wraps WebSocket, handles binary packet decode, emits events by command ID
- `GameScene` tracks local player + other players via `otherPlayers` Map
- Portals defined per-map in `PORTALS_BY_MAP`, collision detection in `update()`, triggers `cmd:14005` map switch
- Server sends player list via `cmd:14001` (both batch `{players:[...]}` and single `{userId,...}` formats)
- Map player list is requested by client via `cmd:10007` after scene loads (avoids timing issues with immediate server push)

## Missing Pieces
- **Original server code**: Damage formulas, attr systems, drop tables, validation — must be reverse-engineered or recreated
- **`com.gfp.core.*` and `com.taomee.*` frameworks**: Core engine classes not in this repo
- **Game assets**: All visual/audio resources must be extracted from original SWF files
- **No game assets yet**: Frontend uses placeholder shapes (red/blue rectangles for players, yellow circles for portals)

## Development Commands

### Build and run the server
```bash
cd gfp-rebuild/server
npm run build        # Compile TypeScript -> dist/
npm run start        # Run the mock server (default port 8080)
npm run dev          # Build + run in one step
```

### Run the frontend
```bash
cd gfp-rebuild/frontend
npm run dev          # Vite dev server
npm run build        # Type-check + build for production
npx tsc --noEmit     # Type-check only
```

### Build the client library
```bash
cd gfp-rebuild/client
npm run build        # Compile TypeScript -> dist/
```

### Run client tests
```bash
cd gfp-rebuild/client
npm test             # Run vitest unit tests (enum/type validation)
npm run test:watch   # Vitest watch mode
npm run test:coverage # Coverage report
```

### Run test client
```bash
cd gfp-rebuild
npm test             # Runs test-client.js (login, movement, skill tests against localhost:8080)
```

### Quick start the server
```bash
node start-server.js  # Launches server in background from repo root
```

## Key Files

| Purpose | Path |
|---------|------|
| Game entry (AS3) | `clientappdll/src/com/gfp/app/MainEntry.as` |
| ClientApp entry | `clientappdll/src/ClientApp_DLL.as` |
| ClientCore entry | `clientcoredll/src/ClientCoreDLL.as` |
| Server (mock) | `gfp-rebuild/server/src/index.ts` |
| Server packet codec | `gfp-rebuild/server/src/protocol/PacketCodec.ts` |
| Server map handler | `gfp-rebuild/server/src/handlers/MapHandler.ts` |
| Server type defs | `gfp-rebuild/server/src/types/` |
| Server map types | `gfp-rebuild/server/src/types/map.ts` |
| Client socket | `gfp-rebuild/client/src/network/SocketClient.ts` |
| Client packet encoder | `gfp-rebuild/client/src/network/PacketEncoder.ts` |
| Client packet decoder | `gfp-rebuild/client/src/network/PacketDecoder.ts` |
| Command enum (250+) | `gfp-rebuild/client/src/network/CommandID.ts` |
| Frontend entry | `gfp-rebuild/frontend/src/index.ts` |
| Frontend game config | `gfp-rebuild/frontend/src/Game.ts` |
| Frontend network wrapper | `gfp-rebuild/frontend/src/managers/GameNetwork.ts` |
| Frontend game scene | `gfp-rebuild/frontend/src/scenes/GameScene.ts` |
| Bean registry | `xml/dll.xml` |
| Server config | `xml/Server.xml` |
| Architecture doc (AS3) | `gfp-rebuild/src/com/gfp/app/MainEntry.as` |
| Rebuild tech doc | `复刻技术文档.md` |

## Notes
- Frontend connects to `ws://localhost:8080` (defined in `frontend/src/managers/GameNetwork.ts`)
- Server listens on port 8080, frontend on Vite default port (typically 5173)
- Map switch uses `cmd:14005`, player list request uses `cmd:10007`
- Player movement uses `cmd:1001` (MOVE), `cmd:1002` (STAND), `cmd:1003` (JUMP)
- Each `gfp-rebuild/subproject/` has its own independent `node_modules/` and `tsconfig.json` — no npm workspaces or monorepo tooling
- AS3 projects use `asconfig.json` for AIR/SWF compilation
