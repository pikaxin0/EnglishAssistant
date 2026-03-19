## 1. Project Setup

- [x] 1.1 Initialize root package.json with project metadata
- [x] 1.2 Set up TypeScript configuration (tsconfig.json)
- [x] 1.3 Create project directory structure (cli/, server/, web/, shared/, database/)
- [x] 1.4 Create .env.example file with OPENAI_API_KEY, OPENAI_BASE_URL, PORT variables
- [x] 1.5 Install shared dependencies (better-sqlite3, dotenv, typescript, @types/node)

## 2. Shared Modules

- [x] 2.1 Create shared/db.ts with Database class and schema initialization
- [x] 2.2 Implement insertTranslation() method in shared/db.ts
- [x] 2.3 Implement getTranslations() method in shared/db.ts (returns all, sorted DESC)
- [x] 2.4 Create shared/ai.ts with OpenAI-compatible client
- [x] 2.5 Implement translate(text) method in shared/ai.ts with error handling
- [x] 2.6 Add environment variable loading for OPENAI_API_KEY and OPENAI_BASE_URL

## 3. CLI Implementation

- [x] 3.1 Create cli/index.ts entry point
- [x] 3.2 Parse process.argv for text argument (handle missing argument)
- [x] 3.3 Call shared/ai.ts translate() with the input text
- [x] 3.4 On success: save to database via shared/db.ts, output translation to stdout, exit 0
- [x] 3.5 On failure: output error message to stdout, exit 1
- [x] 3.6 Handle missing OPENAI_API_KEY (error message, exit 1)
- [x] 3.7 Add bin entry to package.json for CLI execution

## 4. Database Setup

- [x] 4.1 Create database/ directory initialization script
- [x] 4.2 Implement auto-creation of database file if missing
- [x] 4.3 Create translations table with schema (id, original, translated, created_at)
- [x] 4.4 Add index on created_at column for time-based queries
- [x] 4.5 Test concurrent access (CLI write + server read)

## 5. Web Server (Express)

- [x] 5.1 Create server/index.ts with Express app
- [x] 5.2 Implement GET /api/translations endpoint (returns all translations as JSON)
- [x] 5.3 Implement GET /api/health endpoint (returns { status: 'ok' })
- [x] 5.4 Add error handling for database errors (500 status with error message)
- [x] 5.5 Configure PORT from environment variable (default 3000)
- [x] 5.6 Set up CORS for development mode (NODE_ENV=development)
- [x] 5.7 Configure static file serving for React build (production mode)

## 6. React Frontend Setup

- [x] 6.1 Initialize Vite + React project in web/ directory
- [x] 6.2 Install Tailwind CSS with PostCSS configuration
- [x] 6.3 Create web/src/App.tsx main component
- [x] 6.4 Set up Vite proxy configuration for /api/* to Express server
- [x] 6.5 Create web/src/components/KanbanBoard.tsx for layout
- [x] 6.6 Create web/src/components/Column.tsx for column display
- [x] 6.7 Create web/src/components/TranslationCard.tsx for card display

## 7. Kanban UI Implementation

- [x] 7.1 Implement two-column layout (Recent / Older) with Tailwind
- [x] 7.2 Add responsive design (stack on mobile, side-by-side on desktop)
- [x] 7.3 Implement useEffect to fetch /api/translations on mount
- [x] 7.4 Add loading state while fetching translations
- [x] 7.5 Add error handling for failed API requests
- [x] 7.6 Filter translations: Recent (>= 7 days) vs Older (< 7 days)
- [x] 7.7 Sort translations by created_at DESC within each column
- [x] 7.8 Display card content: original text, translated text, timestamp
- [x] 7.9 Format timestamp in human-readable format
- [x] 7.10 Handle empty column state

## 8. Development Scripts

- [x] 8.1 Add npm run dev script (runs both Vite dev server and Express API)
- [x] 8.2 Add npm run build script (builds React app for production)
- [x] 8.3 Add npm run start script (runs Express server serving production build)
- [x] 8.4 Add npm run cli script for testing CLI manually

## 9. Testing & Verification

- [x] 9.1 Test CLI with valid text input (check stdout output, database insert)
- [x] 9.2 Test CLI with no arguments (check error message, exit code 1)
- [x] 9.3 Test CLI with missing API key (check error message, exit code 1)
- [x] 9.4 Test CLI with API error (check error message in stdout, no database insert)
- [x] 9.5 Test GET /api/translations returns correct JSON format
- [x] 9.6 Test GET /api/health returns { status: 'ok' }
- [x] 9.7 Test React app displays kanban with two columns
- [x] 9.8 Test time-based filtering (Recent vs Older columns)
- [x] 9.9 Test concurrent CLI write + server read operations
- [x] 9.10 Test database auto-creation on first run

## 10. Documentation

- [x] 10.1 Create README.md with project overview and setup instructions
- [x] 10.2 Document AHK integration (CLI interface contract: stdin/stdout)
- [x] 10.3 Document environment variables (.env.example)
- [x] 10.4 Document API endpoints (/api/translations, /api/health)
- [x] 10.5 Document npm scripts (dev, build, start, cli)
