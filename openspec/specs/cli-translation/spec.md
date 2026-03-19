## ADDED Requirements

### Requirement: CLI accepts text as command-line argument

The system SHALL provide a CLI tool that accepts text to translate as a command-line argument.

#### Scenario: CLI invoked with text argument

- **WHEN** user runs `node cli.js "Hello world"`
- **THEN** the CLI processes "Hello world" as the text to translate

#### Scenario: CLI invoked without arguments

- **WHEN** user runs `node cli.js` without arguments
- **THEN** the CLI outputs an error message to stdout
- **AND** exits with code 1

### Requirement: CLI outputs translation to stdout

The system SHALL output the translation result directly to stdout without formatting.

#### Scenario: Successful translation output

- **WHEN** translation is successful
- **THEN** only the translated text is written to stdout
- **AND** the process exits with code 0

#### Scenario: Failed translation output

- **WHEN** translation fails (API error, network error, etc.)
- **THEN** an error message describing the failure is written to stdout
- **AND** the process exits with code 1

#### Scenario: Output includes error details

- **WHEN** an error occurs during translation
- **THEN** the stdout content includes sufficient detail for user to understand the failure (e.g., "Error: Failed to connect to AI server - Connection refused")

### Requirement: CLI saves translation to database

The system SHALL save all translation attempts (successful or failed) to the SQLite database.

#### Scenario: Successful translation is saved

- **WHEN** translation is successful
- **THEN** the original text, translated text, and timestamp are saved to the database

#### Scenario: Failed translation is not saved

- **WHEN** translation fails
- **THEN** no record is created in the database

### Requirement: CLI uses OpenAI-compatible API

The system SHALL call an OpenAI-compatible API to perform translation.

#### Scenario: API is called with original text

- **WHEN** the CLI receives text to translate
- **THEN** the AI API is called with the original text as input
- **AND** the API response (translation) is returned to stdout

#### Scenario: API base URL is configurable

- **WHEN** the OPENAI_BASE_URL environment variable is set
- **THEN** the CLI uses that URL for API requests
- **AND** defaults to standard OpenAI API URL if not set

### Requirement: CLI uses configured API key

The system SHALL authenticate with the AI API using an API key from environment configuration.

#### Scenario: API key from environment

- **WHEN** the OPENAI_API_KEY environment variable is set
- **THEN** the CLI uses that key for API authentication

#### Scenario: Missing API key

- **WHEN** the OPENAI_API_KEY environment variable is not set
- **THEN** the CLI outputs an error to stdout
- **AND** exits with code 1
