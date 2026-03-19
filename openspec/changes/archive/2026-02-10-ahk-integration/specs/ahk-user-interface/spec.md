## ADDED Requirements

### Requirement: Borderless GUI display for translation result

The system SHALL display the translation result in a borderless AHK Gui window.

#### Scenario: Successful translation GUI

- **WHEN** the CLI returns a successful translation
- **THEN** a borderless Gui appears at the cursor position showing the translated text
- **AND** the Gui remains visible until dismissed by user action

#### Scenario: Error GUI

- **WHEN** the CLI returns an error message
- **THEN** a borderless Gui appears at the cursor position showing the error message
- **AND** the Gui is visually distinct (e.g., different background color or "Error: " prefix)

### Requirement: GUI content

The system SHALL display the translated text in the Gui window.

#### Scenario: Text display

- **WHEN** the translation result is displayed
- **THEN** the Gui shows the translated text
- **AND** original text is NOT shown (Gui shows only translation)
- **AND** text is readable with appropriate font and colors

#### Scenario: Multi-line text

- **WHEN** the translation result contains multiple lines
- **THEN** the Gui displays the full text with line breaks preserved
- **AND** the Gui height adjusts to fit content

### Requirement: GUI positioning

The system SHALL position the Gui at the mouse cursor location.

#### Scenario: Cursor position

- **WHEN** the Gui is displayed
- **THEN** the Gui appears at the current cursor position with small offset
- **AND** the Gui does not obscure the cursor or selected text

#### Scenario: Screen edge handling

- **WHEN** the cursor is near a screen edge
- **THEN** the Gui adjusts position to remain fully visible on screen

### Requirement: Left-click dismiss

The system SHALL dismiss the Gui when the user clicks outside of it.

#### Scenario: Click outside to dismiss

- **WHEN** the user clicks the left mouse button outside the Gui window
- **THEN** the Gui is immediately hidden
- **AND** the click passes through to the underlying application

#### Scenario: Click inside GUI

- **WHEN** the user clicks inside the Gui window
- **THEN** the Gui remains visible
- **AND** the click can be handled for future actions (e.g., buttons, copy)

### Requirement: GUI appearance

The system SHALL provide a clean, minimal appearance for the Gui.

#### Scenario: Borderless window

- **WHEN** the Gui is displayed
- **THEN** the window has no title bar, borders, or controls
- **AND** only the content is visible

#### Scenario: Always-on-top

- **WHEN** the Gui is displayed
- **THEN** the window stays above other applications
- **AND** the Gui does not steal keyboard focus

#### Scenario: Dark theme

- **WHEN** the Gui is displayed
- **THEN** the background uses a dark color (e.g., #202020)
- **AND** text uses a light color for contrast

### Requirement: Loading indicator

The system SHALL show visual feedback while translation is in progress.

#### Scenario: Progress GUI during translation

- **WHEN** the CLI is executing (which may take 2-5 seconds)
- **THEN** a borderless Gui appears showing "Translating..." or similar text
- **AND** the Gui remains visible until the translation completes
- **AND** the Gui is replaced by the result or error Gui when complete

### Requirement: Non-intrusive behavior

The system SHALL minimize disruption to the user's workflow.

#### Scenario: No focus stealing

- **WHEN** the Gui appears and disappears
- **THEN** keyboard focus remains with the active application
- **AND** the user can continue typing immediately

#### Scenario: Overlapping GUIs

- **WHEN** the user triggers a new translation while a Gui is visible
- **THEN** the old Gui is destroyed and replaced by the new one
- **AND** no duplicate GUIs appear

#### Scenario: Persistent display

- **WHEN** no user action is taken
- **THEN** the Gui remains visible indefinitely
- **AND** the Gui does not disappear on its own

### Requirement: Extensibility for future actions

The system SHALL support adding interactive elements to the Gui in the future.

#### Scenario: Control support

- **WHEN** the Gui is created
- **THEN** the Gui structure allows adding buttons, links, or other controls
- **AND** controls can be added without redesigning the entire Gui
