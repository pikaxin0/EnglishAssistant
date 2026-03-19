## ADDED Requirements

### Requirement: SQLite database schema

The system SHALL use SQLite with a minimal schema for storing translations.

#### Scenario: Translations table structure

- **WHEN** the database is initialized
- **THEN** a `translations` table exists with columns:
  - `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
  - `original` (TEXT NOT NULL)
  - `translated` (TEXT NOT NULL)
  - `created_at` (DATETIME DEFAULT CURRENT_TIMESTAMP)

#### Scenario: Index on timestamp

- **WHEN** the database is initialized
- **THEN** an index exists on `created_at` for efficient time-based queries

### Requirement: Database auto-initialization

The system SHALL automatically create the database file and schema if they do not exist.

#### Scenario: First run creates database

- **WHEN** the application runs and the database file does not exist
- **THEN** the `database/` directory is created
- **AND** the SQLite database file is created
- **AND** the schema is initialized

#### Scenario: Existing database is used

- **WHEN** the application runs and the database file exists
- **THEN** the existing database is opened
- **AND** no schema migration is performed (no versioning in v1)

### Requirement: Insert translation record

The system SHALL provide a method to insert a translation record into the database.

#### Scenario: Successful insert

- **WHEN** a translation is inserted with original and translated text
- **THEN** a new record is created with auto-incremented id
- **AND** created_at is set to current timestamp

#### Scenario: Insert returns record ID

- **WHEN** a translation is successfully inserted
- **THEN** the database returns the ID of the new record

### Requirement: Query translations by time range

The system SHALL support querying translations filtered by creation time.

#### Scenario: Query recent translations

- **WHEN** querying for translations from the last 7 days
- **THEN** records where `created_at >= datetime('now', '-7 days')` are returned
- **AND** results are sorted by `created_at DESC`

#### Scenario: Query older translations

- **WHEN** querying for translations older than 7 days
- **THEN** records where `created_at < datetime('now', '-7 days')` are returned
- **AND** results are sorted by `created_at DESC`

#### Scenario: Query all translations

- **WHEN** querying for all translations without time filter
- **THEN** all records are returned
- **AND** results are sorted by `created_at DESC`

### Requirement: Database file location

The system SHALL store the database at a predictable relative path.

#### Scenario: Default database location

- **WHEN** the application starts
- **THEN** the database file is located at `./database/english_assistant.db`

### Requirement: Shared database access

The system SHALL allow both CLI and web server to access the same database file concurrently.

#### Scenario: CLI writes while server reads

- **WHEN** the CLI inserts a translation while the web server is querying
- **THEN** both operations succeed without database lock errors
- **AND** the web server can see new translations after refresh

### Requirement: Database connection management

The system SHALL properly manage database connections.

#### Scenario: Connection is opened when needed

- **WHEN** a database operation is required
- **THEN** a connection is opened to the database

#### Scenario: Connection is closed after operation

- **WHEN** a database operation completes
- **THEN** the connection is properly closed
- **AND** no database file locks remain
