## ADDED Requirements

### Requirement: GET /api/translations endpoint

The system SHALL provide a REST API endpoint to retrieve translation history.

#### Scenario: Successful request returns all translations

- **WHEN** a GET request is made to `/api/translations`
- **THEN** the response contains all translation records
- **AND** records are sorted by `created_at DESC`
- **AND** response status is 200

#### Scenario: Response format

- **WHEN** translations are retrieved
- **THEN** each record includes: `id`, `original`, `translated`, `created_at`
- **AND** the response is JSON format

### Requirement: API serves on configurable port

The system SHALL serve the API on a port configurable via environment variable.

#### Scenario: Default port 3000

- **WHEN** the PORT environment variable is not set
- **THEN** the server runs on port 3000

#### Scenario: Custom port from environment

- **WHEN** the PORT environment variable is set to 8080
- **THEN** the server runs on port 8080

### Requirement: API serves static React files

The system SHALL serve the React application's static files.

#### Scenario: Production build served

- **WHEN** running in production mode
- **THEN** the server serves static files from the React build directory
- **AND** all non-API routes return the React app's index.html

#### Scenario: API routes are not intercepted

- **WHEN** a request is made to `/api/*`
- **THEN** the request is handled by the API router
- **AND** static file serving does not intercept it

### Requirement: CORS for local development

The system SHALL support CORS for development when Vite dev server runs on a different port.

#### Scenario: CORS enabled in development

- **WHEN** the NODE_ENV is 'development'
- **THEN** CORS headers allow requests from Vite dev server port
- **AND** credentials are not required (same-origin)

### Requirement: Error handling for database errors

The system SHALL return appropriate error responses when database operations fail.

#### Scenario: Database connection error

- **WHEN** the database cannot be accessed
- **THEN** the API returns a 500 status
- **AND** the response includes an error message

#### Scenario: Query error

- **WHEN** a database query fails
- **THEN** the API returns a 500 status
- **AND** the response includes an error message

### Requirement: API server health

The system SHALL provide a health check endpoint.

#### Scenario: Health check returns OK

- **WHEN** a GET request is made to `/api/health`
- **THEN** the response status is 200
- **AND** the response includes `{ status: 'ok' }`

### Requirement: Development mode API proxy

The system SHALL support proxying API requests during development.

#### Scenario: Vite dev server proxies API requests

- **WHEN** running in development mode with Vite
- **THEN** Vite proxies `/api/*` requests to the Express server
- **AND** CORS issues are avoided
