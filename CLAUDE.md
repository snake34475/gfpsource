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
│   └── server/              # Mock game server: GFPServer with login/movement/skill handlers
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
- **Server**: `gfp-rebuild/server/src/index.ts` — `GFPServer` class with in-memory player state, handlers for login (10001/10004/10005/10006), movement (1001/1002/1003/1004), skills (2004), pickup (3001)
- **Client library**: `gfp-rebuild/client/src/` — `SocketClient` (EventEmitter) with reconnection, `CommandID.ts` enum with 250+ commands, typed data structures for battle and user
- The rebuild's server handlers are inlined in `index.ts`; the `handlers/` and `types/` directories under `server/src/` are empty

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
| Server (mock) | `gfp-rebuild/server/src/index.ts` |
| Server packet codec | `gfp-rebuild/server/src/protocol/PacketCodec.ts` |
| Client socket | `gfp-rebuild/client/src/network/SocketClient.ts` |
| Client packet encoder | `gfp-rebuild/client/src/network/PacketEncoder.ts` |
| Client packet decoder | `gfp-rebuild/client/src/network/PacketDecoder.ts` |
| Command enum (250+) | `gfp-rebuild/client/src/network/CommandID.ts` |
| Battle types | `gfp-rebuild/client/src/types/battle.ts` |
| User types | `gfp-rebuild/client/src/types/user.ts` |
| Bean registry | `xml/dll.xml` |
| Server config | `xml/Server.xml` |
| Architecture doc | `源码架构分析文档.md` |
| Rebuild tech doc | `复刻技术文档.md` |
