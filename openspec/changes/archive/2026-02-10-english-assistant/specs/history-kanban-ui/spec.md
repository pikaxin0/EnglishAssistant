## ADDED Requirements

### Requirement: Two-column kanban layout

The system SHALL display translation history in a two-column kanban board layout.

#### Scenario: Kanban renders two columns

- **WHEN** the application loads
- **THEN** two columns are displayed side by side: "Recent" and "Older"
- **AND** columns have equal width
- **AND** columns are responsive (stack on mobile)

#### Scenario: Column definitions

- **WHEN** the kanban is displayed
- **THEN** the "Recent" column shows translations from the last 7 days
- **AND** the "Older" column shows translations older than 7 days

### Requirement: Translation cards display original and translated text

The system SHALL display each translation as a card showing both original and translated text.

#### Scenario: Card content

- **WHEN** a translation card is rendered
- **THEN** the card displays the original text
- **AND** the card displays the translated text
- **AND** the text is visually distinct (e.g., original on top, translated below)

#### Scenario: Card timestamp

- **WHEN** a translation card is rendered
- **THEN** the card displays the creation timestamp
- **AND** the timestamp is formatted in a human-readable format

### Requirement: Fetch translations on mount

The system SHALL fetch all translations from the API when the application loads.

#### Scenario: Initial data fetch

- **WHEN** the application mounts
- **THEN** a GET request is made to `/api/translations`
- **AND** the response is stored in application state

#### Scenario: Loading state

- **WHEN** translations are being fetched
- **THEN** a loading indicator is displayed
- **AND** no cards are shown until data is loaded

#### Scenario: Error handling

- **WHEN** the API request fails
- **THEN** an error message is displayed
- **AND** the application does not crash

### Requirement: Filter translations by time for columns

The system SHALL filter translations into the appropriate column based on creation time.

#### Scenario: Recent column filtering

- **WHEN** translations are loaded
- **THEN** records with `created_at` within the last 7 days appear in the "Recent" column
- **AND** records are sorted by `created_at DESC` within the column

#### Scenario: Older column filtering

- **WHEN** translations are loaded
- **THEN** records with `created_at` older than 7 days appear in the "Older" column
- **AND** records are sorted by `created_at DESC` within the column

#### Scenario: Empty column state

- **WHEN** a column has no translations
- **THEN** the column is displayed with an empty state message or is blank

### Requirement: Tailwind CSS styling

The system SHALL use Tailwind CSS for styling the kanban interface.

#### Scenario: Tailwind classes applied

- **WHEN** components are rendered
- **THEN** all styling uses Tailwind utility classes
- **AND** no custom CSS files are required for layout

#### Scenario: Responsive design

- **WHEN** the application is viewed on different screen sizes
- **THEN** columns stack vertically on mobile
- **AND** columns are side-by-side on desktop
- **AND** breakpoints use Tailwind's responsive modifiers

### Requirement: Read-only interface

The system SHALL be a read-only interface with no editing capabilities.

#### Scenario: No drag-drop functionality

- **WHEN** the application loads
- **THEN** cards cannot be dragged between columns
- **AND** column assignment is based solely on time

#### Scenario: No edit or delete

- **WHEN** viewing translation cards
- **THEN** no edit or delete buttons are displayed
- **AND** the interface is for viewing only

### Requirement: Vite development server

The system SHALL use Vite for development tooling.

#### Scenario: Hot module replacement

- **WHEN** code changes are made during development
- **THEN** the browser updates without full page reload
- **AND** application state is preserved when possible

#### Scenario: API proxy configuration

- **WHEN** running `npm run dev`
- **THEN** Vite proxies `/api/*` requests to the Express server
- **AND** the Express server runs on a separate port

### Requirement: React component structure

The system SHALL use React functional components with hooks.

#### Scenario: Main App component

- **WHEN** the application renders
- **THEN** a main `App` component manages state and data fetching
- **AND** sub-components render columns and cards

#### Scenario: State management

- **WHEN** the application runs
- **THEN** React hooks (useState, useEffect) manage state
- **AND** no external state management library is required
