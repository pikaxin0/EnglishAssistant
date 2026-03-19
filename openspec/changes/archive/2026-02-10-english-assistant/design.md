## Context

This is a greenfield project for personal English learning assistance. The system runs entirely locally on Windows, with only external dependency being an OpenAI-compatible API for translation. An external AutoHotKey script (outside this codebase) handles text capture and tooltip display - our Node.js CLI only needs to accept text and output translation to stdout.

**Constraints:**
- Windows-only platform
- Local execution (no cloud deployment)
- Single user (personal use)
- AHK handles all GUI interaction; CLI is text-only

## Goals / Non-Goals

**Goals:**
- Fast CLI translation that returns results via stdout for AHK to capture
- Persistent storage of all translations for later review
- Simple web interface for browsing translation history
- Minimal complexity - personal tool, not production software

**Non-Goals:**
- Multi-user support or authentication
- Cloud deployment or remote access
- Complex kanban features (drag-drop, manual column assignment)
- Advanced translation features (pronunciation, grammar, examples)
- Cross-platform support (Windows only)

## Decisions

### CLI Output via Stdout

**Decision:** CLI outputs translation (or error) directly to stdout with no formatting.

**Rationale:** AHK captures stdout via `RunWait` and displays it in a tooltip. Raw stdout is simplest - AHK can display any content without parsing.

**Alternatives considered:**
- JSON output: Would require AHK to parse JSON, unnecessary complexity
- Exit codes only: Can't convey error messages to user

### SQLite for Storage

**Decision:** SQLite with minimal schema (id, original, translated, created_at).

**Rationale:**
- Embedded database with no separate server process
- Single file, easy to backup/transfer
- Sufficient for single-user personal data
- SQL queries enable time-based filtering for kanban columns

**Alternatives considered:**
- JSON files: No efficient querying, would need to load all data
- PostgreSQL/MongoDB: Overkill for personal tool, requires separate server

### Minimal Kanban: Time-Based Columns

**Decision:** 2 columns based on time (Recent: last 7 days, Older: before 7 days). Read-only, no drag-drop.

**Rationale:** Simple MVP that enables chronological review. Full drag-drop kanban with manual status tracking is unnecessary for browsing translation history.

**Schema:** `SELECT * FROM translations WHERE created_at >= datetime('now', '-7 days')`

### Shared Codebase Structure

**Decision:** Monorepo-style with shared `db.ts` and `ai.ts` modules used by both CLI and web server.

**Rationale:** Both CLI and server need to:
- Connect to the same SQLite database
- Call the same AI API

Sharing code ensures consistency and reduces duplication.

### React + Vite + Tailwind (Option B)

**Decision:** Proper npm setup with Vite, PostCSS, and Tailwind CSS.

**Rationale:** While CDN is simpler for prototyping, proper setup enables:
- Hot module replacement during development
- Build optimization for production
- Better TypeScript integration
- Standard React development experience

**Alternatives considered:**
- Tailwind CDN: No build step, but larger runtime, no purging of unused CSS

### Express Server for API and Static Files

**Decision:** Single Express server that serves React build (or proxies Vite dev) and provides `/api/translations` endpoint.

**Rationale:** Simpler than separate API server and static file server. In development, Vite dev server runs separately with API proxy. In production, Express serves built React files.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| AHK script is external dependency | Document clear CLI interface contract (stdin/stdout) |
| AI API rate limits/costs | Use local AI option (Ollama) if needed; CLI shows errors in tooltip |
| SQLite write concurrency | Low risk: single user, CLI writes are sequential |
| React build complexity | Keep frontend simple; use Vite defaults |
| Windows path issues | Use `path.join()` and `__dirname` for all file paths |

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          EXTERNAL (AHK)                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. Capture selected text                                               │
│  2. RunWait('node cli.js "text"')                                       │
│  3. Read stdout                                                         │
│  4. Show tooltip with stdout content                                    │
│  5. Wait for user click                                                 │
│  6. Exit                                                                 │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         NODE.JS CODEBASE                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                         cli/index.ts                            │    │
│  │                                                                 │    │
│  │  1. Parse process.argv for text                                │    │
│  │  2. Call shared/ai.ts to translate                             │    │
│  │  3. Call shared/db.ts to save                                  │    │
│  │  4. Console.log(result or error)                               │    │
│  │  5. Process.exit(0 or 1)                                       │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                      shared/db.ts                               │    │
│  │                                                                 │    │
│  │  - Database connection (better-sqlite3)                         │    │
│  │  - Schema: translations (id, original, translated, created_at)  │    │
│  │  - Methods: insertTranslation(), getTranslations()             │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                      shared/ai.ts                               │    │
│  │                                                                 │    │
│  │  - OpenAI-compatible client (configurable base URL)            │    │
│  │  - Method: translate(text) -> Promise<string>                  │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                      server/index.ts                            │    │
│  │                                                                 │    │
│  │  - Express server                                               │    │
│  │  - GET /api/translations (returns all, sorted by date desc)    │    │
│  │  - Serve React build (or proxy to Vite in dev)                  │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                      web/src/App.tsx                            │    │
│  │                                                                 │    │
│  │  - 2-column kanban layout (Tailwind)                            │    │
│  │  - Fetch /api/translations on mount                             │    │
│  │  - Filter: Recent (>= 7 days) / Older (< 7 days)                │    │
│  │  - Display cards with original + translated text                │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                          EXTERNAL SERVICES                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  • OpenAI-compatible API (configured via env var)                        │
│  • Database file: ./database/english_assistant.db                       │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## Migration Plan

Not applicable (new project).

## Open Questions

1. **AI API Key Configuration:** How to handle API key? Environment variable or config file?
   - *Likely answer:* `.env` file with `OPENAI_API_KEY` and `OPENAI_BASE_URL`

2. **Database Initialization:** Should CLI auto-create database file if missing?
   - *Likely answer:* Yes, create `database/` dir and initialize schema on first run

3. **Dev Server Startup:** How to run both Vite dev server and Express API during development?
   - *Likely answer:* Separate terminals, or simple `npm run dev` script that runs both with `concurrently`

4. **Port Configuration:** What port for Express server?
   - *Likely answer:* Default to 3000, configurable via `PORT` env var
