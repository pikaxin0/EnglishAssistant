## Why

Personal English learning workflow requires quick translation of selected text with persistent history for review. Existing tools don't provide a simple, local solution that integrates with a custom web interface for browsing translation history.

## What Changes

- **New CLI tool** that accepts text as a command-line argument and outputs translation to stdout
- **AHK integration** where an external AutoHotKey script captures selected text and calls the CLI
- **AI translation** via OpenAI-compatible API (provider-agnostic)
- **SQLite storage** to persist all translations with timestamp
- **React web application** with a 2-column kanban board for browsing translation history
- **Express server** that serves the React app and provides REST API for querying translations

## Capabilities

### New Capabilities

- `cli-translation`: Command-line interface for translating text via AI, outputting to stdout for AHK consumption
- `translation-storage`: SQLite persistence of translations with minimal schema (id, original, translated, created_at)
- `translation-history-api`: REST API endpoint for querying translation history
- `history-kanban-ui`: React web interface displaying translations in a time-based kanban view (Recent: 7 days / Older)

### Modified Capabilities

None (new project)

## Impact

- **New dependencies**: Node.js, SQLite, Express, React, Vite, Tailwind CSS, OpenAI-compatible SDK
- **New files**: CLI entry point, Express server, React app, SQLite database
- **External integration**: AHK script (outside this project) that calls the CLI and displays tooltip
- **Local only**: No network services except AI API calls; database and web server run locally
