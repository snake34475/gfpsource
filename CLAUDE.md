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
│   └── docs/                # Architecture, plan, checklist, verify-guide (Chinese)
├── 源码架构分析文档.md        # Architecture analysis document (Chinese)
└── 复刻技术文档.md          # Rebuild technical document (Chinese)
```

## Architecture

### Original Game (AS3)
- **Thin client**: All damage calculations, drop logic, and validation are server-side (server code is NOT in this repo)
- **Protocol**: TCP binary socket (port 1863), `ByteArray` serialization routed by `CommandID` constants
- **Command/listener pattern**: `xml/dll.xml` registers 60+ Bean classes (command listeners)
- **Manager pattern**: Centralized managers (`FightManager`, `MapManager`, etc.)
- **Factory pattern for maps**: 521 separate `MapProcess_XXXXXX.as` classes, one per map

### Rebuild Project (TypeScript)
- **Protocol**: WebSocket with binary packet format `[length: 4 bytes LE][commandId: 4 bytes LE][body: variable]`
- **Server**: `gfp-rebuild/server/src/index.ts` — `GFPServer` class with in-memory player state; handlers extracted into modular files under `handlers/` (MoveHandler, SkillHandler, BattleHandler, ItemHandler, MapHandler)
- **Client library**: `gfp-rebuild/client/src/` — `SocketClient` (EventEmitter with reconnection), `CommandID.ts` enum (250+ commands), typed data structures (`types/battle.ts`, `types/user.ts`, `types/move.ts`, `types/skill.ts`)
- **Server types**: `server/src/types/` — shared interfaces (Player, Client, GameState, Position) and map-related types (MapInfo, MAP_CONFIG, spawn points)

## Missing Pieces
- **Original server code**: Damage formulas, attr systems, drop tables, validation — must be reverse-engineered or recreated
- **`com.gfp.core.*` and `com.taomee.*` frameworks**: Core engine classes not in this repo
- **Game assets**: All visual/audio resources must be extracted from original SWF files
- **No frontend UI**: The rebuild is protocol-layer only; no React/Phaser frontend exists yet

## Development Commands

### Build and run the server
```bash
cd gfp-rebuild/server
npm run build        # Compile TypeScript -> dist/
npm run start        # Run the mock server (default port 8080)
npm run dev          # Build + run in one step
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
| ClientApp entry | `clientappdll/src/ClientAppDLL.as` |
| ClientCore entry | `clientcoredll/src/ClientCoreDLL.as` |
| Server (mock) | `gfp-rebuild/server/src/index.ts` |
| Server packet codec | `gfp-rebuild/server/src/protocol/PacketCodec.ts` |
| Server move handler | `gfp-rebuild/server/src/handlers/MoveHandler.ts` |
| Server type defs | `gfp-rebuild/server/src/types/` |
| Client socket | `gfp-rebuild/client/src/network/SocketClient.ts` |
| Client packet encoder | `gfp-rebuild/client/src/network/PacketEncoder.ts` |
| Client packet decoder | `gfp-rebuild/client/src/network/PacketDecoder.ts` |
| Command enum (250+) | `gfp-rebuild/client/src/network/CommandID.ts` |
| Battle types | `gfp-rebuild/client/src/types/battle.ts` |
| User/Move/Skill types | `gfp-rebuild/client/src/types/` |
| Bean registry | `xml/dll.xml` |
| Server config | `xml/Server.xml` |
| Architecture doc (AS3) | `源码架构分析文档.md` |
| Rebuild tech doc | `复刻技术文档.md` |
| Protocol architecture | `gfp-rebuild/docs/architecture.md` |
| Rebuild plan | `gfp-rebuild/docs/plan.md` |
| Analysis report | `clientappdll/项目分析报告.md` |
| Story animation doc | `clientappdll/故事动画系统文档.md` |

## Notes
- Test client (`test-client.js`) connects to port 8081 with JSON messages — the actual server listens on port 8080 with binary protocol — port mismatch when running `npm test` from `gfp-rebuild/`
- The `gfp-rebuild/` root has a separate `package.json` (`gfp-test-client` workspace) that installs `ws` for the test scripts
- AS3 projects use `asconfig.json` for AIR/SWF compilation: `clientappdll` outputs `bin/clientappdll.swf`, `clientcoredll` outputs `bin/clientcoredll.swf`
- Each `gfp-rebuild/subproject/` has its own independent `node_modules/` and `tsconfig.json` — no npm workspaces or monorepo tooling
